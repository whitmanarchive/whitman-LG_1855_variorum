require "nokogiri"

class Remover
  include Helpers

  def initialize
    get_current_path
    @rep_path = File.join(@repo_dir, "source/authority/would_have_changed.xml")

    base_path = get_base_path
    manuscripts = Dir["#{base_path}/tei/*"]
    notebooks = Dir["#{base_path}/notebooks/tei/*"]

    @all_files = manuscripts + notebooks
    @changes = {}
  end

  def run
    process_files
    generate_report
  end

  private

  def generate_report
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.would_have_changed {
        @changes.each do |file, list|
          # get less verbose path
          filepath = file.split("..").last
          xml.file("id" => filepath) {
            list.each do |item|
              text = "<#{item[:element]} xml:id=#{item[:id]} corresp=#{item[:corresp]}>"
              xml.send(item[:element],
                "xml:id" => item[:id],
                "corresp" => item[:corresp])
            end
          }
        end
      }
    end

    write_xml_file(@rep_path, builder, 2)
  end

  def get_base_path
    "/var/local/www/cocoon/whitmanarchive/manuscripts"
  end

  def process_files
    @all_files.each do |file|
      xml = open_xml(file)
      filename = File.basename(file)
      # need to look for any elements that have an attribute which
      # includes ANYWHERE #l0 to #l2314
      eles = xml.xpath("//*[contains(@corresp, '#l')]")
      puts "#{filename}: #{eles.length}"
      eles.each do |ele|
        # if any portion of the attribute matches an l id,
        # nuke the entire corresp  D: !
        if ele["corresp"][/#l\d{1,4}(?: |$)/]
          report_change(file, ele)
          # NOTE: we have decided not to use this script for actual
          # deletion but instead will simply be generating a report
          # ele.delete("corresp")
        end
      end
      # write_xml_file(file, xml, 2)
    end
  end

  def report_change(file, ele)
    if !@changes.key?(file)
      @changes[file] = []
    end

    @changes[file] << {
      element: ele.name,
      id: ele["xml:id"],
      corresp: ele["corresp"]
    }
  end

end
