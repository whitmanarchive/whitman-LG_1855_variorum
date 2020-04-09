require "fileutils"
require "iiif/presentation"
require "nokogiri"
require "yaml"

require_relative "file_type.rb"

class FileTei < FileType

  def get_toc
    path = File.join(
      @options["collection_dir"],
      "source", "authority",
      "lg_viewer_table_of_contents.yml"
    )
    begin
      YAML.load_file(path)
    rescue => e
      raise "could not find file #{path} for table of contents!"
    end
  end

  def transform_iiif
    # if this isn't the main file in question, we don't want any part of it
    return {} if !@file_location.include?("ppp.01880.xml")

    set_iiif_paths()
    iiif_path = File.join(@options["iiif_base"], @options["iiif_fig_dir"])

    # create a manifest with basic LoG stuff

    manifest = IIIF::Presentation::Manifest.new({
      "@id" => "#{@iiif_output_path}/leaves_of_grass.json",
      "label" => "Leaves of Grass (1855)",
      #"description" => [
      #  "@value" => "This is a description",
      #  "@language" => "en"
      # ],
      # "license" => "some license information here",
      "attribution" => "University of Iowa Libraries, Special Collections &amp; University Archives",
      "viewingDirection" => "left-to-right",
      "viewingHint" => "paged",
      # "logo" => "#{iiif_path}ppp.00271.001.jpg/#{@options["iiif_thumb_end"]}"
    })

    toc = get_toc()

    manifest["structures"] = toc.map do |item|
      {
        "@id" => "#{@iiif_output_path}/structure/#{item["s_id"]}.json",
        "@type" => "sc:Canvas",
        "label" => item["label"],
        "canvases" => [ "#{@iiif_output_path}/canvas/#{item["c_id"]}.json" ]
      }
    end

    sequence_primary = IIIF::Presentation::Sequence.new({
      "label" => "Page Order"
    })

    xml = File.open(@file_location) { |f| Nokogiri::XML(f).remove_namespaces! }

    pbs = xml.xpath("//pb")

    # I think I am under the impression we will want one canvas
    # for each page of LoG which is annotated with the image
    # and possibly with the text
    pbs.each do |page|
      image_filename = page["facs"]
      puts image_filename
      canvas = IIIF::Presentation::Canvas.new()
      full_url = "#{iiif_path}%2F#{image_filename}/#{@options["iiif_fullsize_end"]}"
      thumb_url = "#{iiif_path}%2F#{image_filename}/#{@options["iiif_thumb_end"]}"

      canvas["@id"] = "#{@iiif_output_path}/canvas/#{image_filename}-#{page["id"]}.json"
      canvas.label = "#{page["rend"]} #{page["id"]}"
      canvas.thumbnail = thumb_url

      # create an annotation
      # TODO fill in more annotation stuff
      annotation = IIIF::Presentation::Annotation.new
      annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
        service_id: "#{iiif_path}%2F#{image_filename}"
      })
      # TODO see this part of documentation for "on": https://iiif.io/api/presentation/2.1/#image-resources
      annotation["on"] = "#{@iiif_output_path}/canvas/#{image_filename}-#{page["id"]}"
      annotation["@id"] = "#{@iiif_output_path}/annotation/#{image_filename}"
      canvas.images << annotation
      canvas.width = annotation.resource.width
      canvas.height = annotation.resource.height
      # attach an annotation to the frontispiece
      if image_filename == "ppp.00271.007.jpg"
        canvas["otherContent"] = [
          {
            # TODO this should perhaps be in a subdirectory of annotationList
            "@id" => "#{@iiif_output_path}/frontispiece.json",
            "@type" => "sc:AnnotationList"
          }
        ]
      end
      # output all the canvas methods for inspection
      # puts canvas.methods(false).sort

      sequence_primary.canvases << canvas
    end

    manifest.sequences << sequence_primary
    File.open(File.join(@iiif_output_dir, "leaves_of_grass.json"), "w") { |f| f.write(manifest.to_json(pretty: true)) }
    manifest
  end
end
