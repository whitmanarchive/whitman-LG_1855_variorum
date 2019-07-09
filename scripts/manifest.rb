require "fileutils"
require "iiif/presentation"
require "nokogiri"

# iiif config
iiif_path = "https://whitmanarchive.org/iiif/2/published%2FLG%2Ffigures%2F"
iiif_end = "full/full/0/default.jpg"
iiif_thumb = "full/!150,150/0/default.jpg"

# create a manifest with basic LoG stuff

manifest = IIIF::Presentation::Manifest.new({
  "@id" => "https://cdrhmedia.unl.edu/data/whitman-variorum/output/development/manifests/leaves_of_grass.json",
  "label" => "Leaves of Grass 1855 First Edition",
  "description" => [
    "@value" => "This is a description",
    "@language" => "en"
  ],
  # "license" => "some license information here",
  "attribution" => "Walt Whitman or other attribution",
  "viewingDirection" => "left-to-right",
  "viewingHint" => "paged",
  "logo" => "#{iiif_path}%2Fppp.00217.001.jpg/#{iiif_thumb}"
})

toc = [
  { s_id: "front_cover", c_id: "ppp.00271.001.jpg-leaf001r",
    label: 'Front Cover' },
  { s_id: "emerson", c_id: "ppp.00271.005.jpg-leaf002v",
    label: 'Emerson Letter' },
  { s_id: "frontispiece", c_id: "ppp.00271.007.jpg-leaf003v",
    label: 'Frontispiece' },
  { s_id: "title", c_id: "ppp.00271.008.jpg-leaf004r",
    label: 'Title Page' },
  { s_id: "copyright", c_id: "ppp.00271.009.jpg-leaf004v",
    label: 'Copyright Page' },
  { s_id: "preface", c_id: "ppp.00271.010.jpg-leaf005r",
    label: 'Preface' },
  { s_id: "log1", c_id: "ppp.00271.020.jpg-leaf010r",
    label: 'Leaves of Grass [1] ("Song of Myself")' },
  { s_id: "log2", c_id: "ppp.00271.064.jpg-leaf032r",
    label: 'Leaves of Grass [2] ("A Song for Occupations")' },
  { s_id: "log3", c_id: "ppp.00271.072.jpg-leaf036r",
    label: 'Leaves of Grass [3], ("To Think of Time")' },
  { s_id: "log4", c_id: "ppp.00271.077.jpg-leaf038v",
    label: 'Leaves of Grass [4], ("The Sleepers")' },
  { s_id: "log5", c_id: "ppp.00271.084.jpg-leaf042r",
    label: 'Leaves of Grass [5], ("I Sing the Body Electric")' },
  { s_id: "log6", c_id: "ppp.00271.089.jpg-leaf044v",
    label: 'Leaves of Grass [6], ("Faces")' },
  { s_id: "untitled1", c_id: "ppp.00271.092.jpg-leaf046r",
    label: 'Untitled [1], ("Song of the Answerer")' },
  { s_id: "untitled2", c_id: "ppp.00271.094.jpg-leaf047r",
    label: 'Untitled [2], ("Europe, The 72d and 73d Years of these States")' },
  { s_id: "untitled3", c_id: "ppp.00271.096.jpg-leaf048r",
    label: 'Untitled [3], ("A Boston Ballad")' },
  { s_id: "untitled4", c_id: "ppp.00271.097.jpg-leaf048v",
    label: 'Untitled [4], ("There Was a Child Went Forth")' },
  { s_id: "untitled5", c_id: "ppp.00271.099.jpg-leaf049v",
    label: 'Untitled [5], ("Who Learns My Lesson Complete")' },
  { s_id: "untitled6", c_id: "ppp.00271.100.jpg-leaf050r",
    label: 'Untitled [6], ("Youth, Day, Old Age and Night")' },
  { s_id: "review1", c_id: "ppp.00271.106.jpg-leaf053r",
    label: "Review [1]" },
  # TODO I think this might be the same page as previous?
  { s_id: "ww1", c_id: "ppp.00271.106.jpg-leaf053r",
    label: '"Walt Whitman, A Brooklyn Boy"' },
  { s_id: "ww2", c_id: "ppp.00271.107.jpg-leaf053v",
    label: '"Walt Whitman and His Poems"' },
  { s_id: "review2", c_id: "ppp.00271.107.jpg-leaf054v",
    label: "Review [2]" },
  { s_id: "review3", c_id: "ppp.00271.107.jpg-leaf055r",
    label: "Review [3]" },
  { s_id: "ww3", c_id: "ppp.00271.107.jpg-leaf055r",
    label: '"An English and an American Poet"' },
  { s_id: "ww4", c_id: "ppp.00271.107.jpg-leaf056r",
    label: '"Have Great Poets Become Impossible"' },
  { s_id: "ww5", c_id: "ppp.00271.107.jpg-leaf056v",
    label: '"Extracts from Letters and Reviews"' },
]

manifest["structures"] = toc.map do |item|
  {
    "@id" => "https://whitmanarchive.org/TODO/structure/#{item[:s_id]}",
    "@type" => "sc:Canvas",
    "label" => item[:label],
    "canvases" => [ "https://whitmanarchive.org/TODO/#{item[:c_id]}" ]
  }
end

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
  annotation["@id"] = "https://whitmanarchive.org/TODO/annotation/#{image_filename}"
  canvas.images << annotation
  canvas.width = annotation.resource.width
  canvas.height = annotation.resource.height
  # output all the canvas methods for inspection
  # puts canvas.methods(false).sort

  sequence_primary.canvases << canvas
end

manifest.sequences << sequence_primary
# puts manifest.to_json(pretty: true)

# TODO if this is inside the datura scripts at some point, then use @options["environment"]
output_dir = File.join(File.dirname(__FILE__), "..", "output", "development", "manifests")
FileUtils.mkdir_p(output_dir)
File.open(File.join(output_dir, "leaves_of_grass.json"), "w") { |f| f.write(manifest.to_json(pretty: true)) }
