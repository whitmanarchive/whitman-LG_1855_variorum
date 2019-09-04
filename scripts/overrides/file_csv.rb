# This file does two things:
# - generates a manifest for each snippet
# - generates an index file describing how each
#   manifest should be called for a custom website

require "csv"
require "fileutils"
require "iiif/presentation"

class FileCsv

  def create_canvas(image_path, id, row, crop = false)
    # create a canvas for each snippet, for now just use first image alone
    canvas = IIIF::Presentation::Canvas.new()
    # TODO placeholder for image pending
    if image_path && image_path != "Image pending"
      item_loc = image_path.gsub("/", "%2F")
    else
      item_loc = "whitman-fallback.jpg"
    end
    full_url = "#{@iiif_path}/#{item_loc}/#{@iiif_end}"
    thumb_url = "#{@iiif_path}/#{item_loc}/#{@iiif_thumb}"

    canvas["@id"] = "#{@iiif_output_path}/canvas/#{id}.json"
    canvas.label = row["File Label"]
    canvas.thumbnail = thumb_url

    annotation = IIIF::Presentation::Annotation.new
    begin
      annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
        service_id: "#{@iiif_path}/#{item_loc}"
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

  def transform_iiif
    # iiif config
    @iiif_path = "https://whitmanarchive.org/iiif/2"
    @iiif_end = "full/full/0/default.jpg"
    @iiif_thumb = "full/!150,150/0/default.jpg"
    # note differs from general manifests in that it's in "snippets" subdirectory
    @iiif_output_path = "#{@options["data_base"]}/data/#{@options["collection"]}/output/#{@options["environment"]}/iiif/snippets"
    @iiif_output_dir = "#{@options["collection_dir"]}/output/#{@options["environment"]}/iiif/snippets"

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
        #"logo" => "#{@iiif_path}ppp.00271.001.jpg/#{@iiif_thumb}"
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

      # ADD EACH ROW OF THE CSV TO ITS GROUP, ORDER OF ARRAY MATTERS
      # group = row["Group Name"].downcase.gsub(" ", "-")
      group = row["Group Name"]
      if groups.key?(group)
        groups[group] << id
      else
        groups[group] = [id]
      end
    end

    # create a JSON index file that is used to associate the manifests
    snippets = []
    groups.each do |group, ids|
      link = ids.first[0,7]
      puts link
      snippets << {
        label: group,
        link: link,
        ids: ids
      }
    end

    puts "writing to #{@iiif_output_dir}"
    File.open(File.join(@iiif_output_dir, "index.js"), "w") do |f|
      f.write("var snippets = #{snippets.to_json(pretty: true)}")
    end
    # TODO need to look into this
    { "doc" => snippets }
  end

end