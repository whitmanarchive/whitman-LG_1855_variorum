# This file does two things:
# - generates a manifest for each snippet
# - generates an index file describing how each
#   manifest should be called for a custom website

require "csv"
require "fileutils"
require "iiif/presentation"

require_relative "file_type.rb"

class FileCsv < FileType

  def create_canvas(image_path, id, row, crop = false)
    item_loc = escape_image_path(image_path)
    full_url = File.join(@options["iiif_base"], item_loc, @options["iiif_fullsize_end"])
    thumb_url = File.join(@options["iiif_base"], item_loc, @options["iiif_thumb_end"])

    # create a canvas for each snippet, for now just use first image alone
    canvas = IIIF::Presentation::Canvas.new()
    canvas["@id"] = "#{@iiif_output_path}/canvas/#{id}.json"
    canvas.label = row["File Label"]
    canvas.thumbnail = thumb_url

    annotation = IIIF::Presentation::Annotation.new
    begin
      annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
        service_id: "#{@options["iiif_base"]}/#{item_loc}"
      })
    rescue => e
      puts "Unable to add manuscript for #{item_loc}: #{e}"
      return nil
    end
    annotation["on"] = "#{@iiif_output_path}/canvas/#{id}.json"
    annotation["@id"] = "#{@iiif_output_path}/annotation/#{id}.json"
    canvas.images << annotation
    canvas.width = annotation.resource.width
    canvas.height = annotation.resource.height
    canvas
  end

  # IIIF requires that any nested paths use %2F to distinguish between
  # the path to the image and portions of the IIIF URL
  #
  # If no image currently available, use placeholder
  def escape_image_path(image_path)
    if image_path && image_path != "Image pending"
      image_path.gsub("/", "%2F")
    else
      "whitman-fallback.jpg"
    end
  end

  def reorder_groups(groups)
    groups.map do |group, items|
      # pull first result which matches Iowa
      iowa = items.detect { |hsh| hsh[:repo] == "Special Collections, The University of Iowa Libraries" }
      if iowa
        items.delete(iowa)
        # prepend iowa entry at the front
        items.unshift(iowa)
      end
      { group => items }
    end
    groups
  end

  def transform_iiif
    set_iiif_paths("snippets")

    groups = {}

    FileUtils.mkdir_p(@iiif_output_dir)

    csv = CSV.read(@file_location, headers: true)

    csv.each do |row|
      id = row["ID in variorum file"]
      next if !id
      puts id
      label = "#{row["Group Name"]} #{id}"

      # CREATE A MANIFEST FOR EACH ROW OF THE CSV
      # if there is a cropped version, use that as the first canvas
      # of the manifest, and regardless include the full sized image
      # as a canvas in the manifest

      manifest = IIIF::Presentation::Manifest.new({
        "@id" => "#{@iiif_output_path}/#{id}.json",
        "label" => row["File Label"],
        "description" => [
          "@value" => "#{row["File Label"]} (#{id})",
          "@language" => "en"
        ],
        # "license" => "some license information here",
        "attribution" => row["Repository"],
        "viewingDirection" => "left-to-right",
        "viewingHint" => "paged",
        #"logo" => "#{@options["iiif_base"]}ppp.00271.001.jpg/#{@options["iiif_thumb_end"]}"
      })

      # still has to be a sequence even for one image
      sequence_primary = IIIF::Presentation::Sequence.new({
        "label" => "No Label Yet"
      })

      # create a canvas for the cropped version if it exists and should be included
      if row["Cropped File location"] && !row["Cropped File location"][/[Dd]o not include/]
        canvas = create_canvas(row["Cropped File location"], "#{id}-cropped", row, crop: true)
        sequence_primary.canvases << canvas if canvas
      end
      canvas_uncropped = create_canvas(row["File location"], id, row)
      sequence_primary.canvases << canvas_uncropped if canvas_uncropped

      manifest.sequences << sequence_primary
      # puts manifest.to_json(pretty: true)

      File.open(File.join(@iiif_output_dir, "#{id}.json"), "w") do |f|
        f.write(manifest.to_json(pretty: true))
      end

      # add each row of the spreadsheet to its respective group
      # and pass information about the repo for later sorting
      group = row["Group Name"]
      if !groups.key?(group)
        groups[group] = []
      end
      groups[group] << { id: id, repo: row["Repository"] }
    end

    # create a JSON index file that is used to associate the manifests
    snippets = []
    # reorder groups so that the iowa repository entry (if it exists) is FIRST
    groups = reorder_groups(groups)

    groups.each do |group, items|
      # grab the first id and trim it down a bit to get the generic version
      link = items.first[:id][0,7]
      snippets << {
        label: group,
        link: link,
        ids: items.map { |item| item[:id] }
      }
    end

    puts "writing to #{@iiif_output_dir}"
    File.open(File.join(@iiif_output_dir, "index.js"), "w") do |f|
      f.write("var snippets = #{JSON.pretty_generate(snippets)}")
    end
    # TODO need to look into this
    { "doc" => snippets }
  end

end
