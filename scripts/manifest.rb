require "iiif/presentation"
require "nokogiri"

# iiif config
iiif_path = "https://whitmanarchive.org/iiif/2/published%2FLG%2Ffigures%2F"
iiif_end = "full/full/0/default.jpg"
iiif_thumb = "full/!150,150/0/default.jpg"

# create a manifest with basic LoG stuff

manifest = IIIF::Presentation::Manifest.new({
  "@id" => "https://whitmanarchive.org/TODO",
  "label" => "Leaves of Grass 1855 First Edition",
  "description" => [
    "@value" => "This is a description",
    "@language" => "en"
  ],
  # "license" => "some license information here",
  "attribution" => "Walt Whitman or other attribution"
})

sequence_primary = IIIF::Presentation::Sequence.new({
  "label" => "Page Order"
})

variorum_filepath = File.join(
  File.dirname(__FILE__), "..", "source", "tei", "ppp.00271_var.xml"
)
xml = File.open(variorum_filepath) { |f| Nokogiri::XML(f).remove_namespaces! }

pbs = xml.xpath("//pb")

# I think I am under the impression we will want one canvas
# for each page of LoG which is annotated with the image
# and possibly with the text
pbs.each do |page|
  image_filename = page["facs"]
  puts image_filename
  canvas = IIIF::Presentation::Canvas.new()
  full_url = "#{iiif_path}%2F#{image_filename}/#{iiif_end}"
  thumb_url = "#{iiif_path}%2F#{image_filename}/#{iiif_thumb}"

  canvas["@id"] = "https://whitmanarchive.org/TODO/#{image_filename}-#{page["id"]}"
  canvas.label = "#{page["rend"]} #{page["id"]}"
  canvas.thumbnail = thumb_url

  # create an annotation
  # TODO fill in more annotation stuff
  annotation = IIIF::Presentation::Annotation.new
  annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
    service_id: "#{iiif_path}%2F#{image_filename}"
  })
  # WARNING: Resource type oa:Annotation should have '@id' set
  # TODO see this part of documentation for "on": https://iiif.io/api/presentation/2.1/#image-resources
  annotation["on"] = "https://whitmanarchive.org/TODO/#{image_filename}-#{page["id"]}"
  canvas.images << annotation
  canvas.width = annotation.resource.width
  canvas.height = annotation.resource.height
  # output all the canvas methods for inspection
  # puts canvas.methods(false).sort

  sequence_primary.canvases << canvas
end

manifest.sequences << sequence_primary
# puts manifest.to_json(pretty: true)

File.open("testing.json", "w") { |f| f.write(manifest.to_json(pretty: true)) }
