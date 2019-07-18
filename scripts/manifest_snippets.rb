# GENERATES ONE MANIFEST PER SNIPPET SO THAT THEY
# CAN BE COMPARED SIDE BY SIDE

require "csv"
require "fileutils"
require "iiif/presentation"
require "nokogiri"

# iiif config
iiif_path = "https://whitmanarchive.org/iiif/2"
iiif_end = "full/full/0/default.jpg"
iiif_thumb = "full/!150,150/0/default.jpg"

csv_filepath = File.join(
  File.dirname(__FILE__), "..", "source", "authority", "snippets.csv"
)

csv = CSV.read(csv_filepath, headers: true)

csv.each do |row|
  id = row["manifest id"]
  next if !id
  puts id
  label = "#{row["Group Name"]} #{id}"

  manifest = IIIF::Presentation::Manifest.new({
    "@id" => "https://cdrhmedia.unl.edu/data/whitman-variorum/output/development/manifests/snippets/#{id}.json",
    "label" => row["File Label"],
    "description" => [
      "@value" => row["File Label"],
      "@language" => "en"
    ],
    # "license" => "some license information here",
    "attribution" => "Walt Whitman or other attribution",
    "viewingDirection" => "left-to-right",
    "viewingHint" => "paged",
    "logo" => "#{iiif_path}ppp.00271.001.jpg/#{iiif_thumb}"
  })

  # still has to be a sequence even for one image
  sequence_primary = IIIF::Presentation::Sequence.new({
    "label" => "No Label Yet"
  })

  # create a canvas for each snippet, for now just use first image alone
  canvas = IIIF::Presentation::Canvas.new()

  # TODO placeholder for image pending
  if row["File location"] && row["File location"] != "Image pending"
    item_loc = row["File location"].gsub("/", "%2F")
  else
    item_loc = "test.jpg"
  end
  full_url = "#{iiif_path}/#{item_loc}/#{iiif_end}"
  thumb_url = "#{iiif_path}/#{item_loc}/#{iiif_thumb}"

  canvas["@id"] = "https://whitmanarchive.org/TODO/snippets/#{id}"
  canvas.label = row["File Label"]
  canvas.thumbnail = thumb_url

  annotation = IIIF::Presentation::Annotation.new
  begin
    annotation.resource = IIIF::Presentation::ImageResource.create_image_api_image_resource({
      service_id: "#{iiif_path}/#{item_loc}"
    })
  rescue => e
    puts "Unable to add manuscript for #{item_loc}: #{e}"
    next
  end
  annotation["on"] = "https://whitmanarchive.org/TODO/snippets/#{id}"
  annotation["@id"] = "https://whitmanarchive.org/TODO/annotation/#{id}"
  canvas.images << annotation
  canvas.width = annotation.resource.width
  canvas.height = annotation.resource.height

  sequence_primary.canvases << canvas

  manifest.sequences << sequence_primary
  # puts manifest.to_json(pretty: true)

  # TODO if this is inside the datura scripts at some point, then use @options["environment"]
  output_dir = File.join(
    File.dirname(__FILE__), "..", "output", "development", "manifests", "snippets"
  )
  FileUtils.mkdir_p(output_dir)
  File.open(File.join(output_dir, "#{id}.json"), "w") do |f|
    f.write(manifest.to_json(pretty: true))
  end
end
