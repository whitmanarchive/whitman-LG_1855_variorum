require "nokogiri"

class Datura::DataManager

  def pre_batch_processing
    # can access @files array
    current_dir = File.dirname(__FILE__)

    mss_filepath = File.join(
      current_dir, "../..", "source", "authority", "manuscript_list.txt"
    )
    mss_file_list = File.readlines(mss_filepath).map { |f| f.strip }

    # create a work id object which will track manuscripts that contain a work
    work_ids = {}
    not_found = []

    mss_tei_dir = File.join(
      current_dir, "../../../", "whitman-manuscripts", "source", "tei"
    )
    mss_file_list.each do |mss_file|
      path = File.join(mss_tei_dir, mss_file)
      if File.file?(path)
        xml = File.open(path) { |f| Nokogiri::XML(f).remove_namespaces! }
        works = xml.xpath("/TEI/relations/work")
        works.each do |work|
          ref = work["ref"]
          certainty = work["certainty"] || work["cert"] || "not marked"
          if ref
            obj = { mss: mss_file, certainty: certainty }
            if work_ids.key?(ref)
              work_ids[ref] << obj
            else
              work_ids[ref] = [obj]
            end
          else
            puts "No reference work id found in #{mss_file}"
          end
        end
      else
        not_found << mss_file
      end
    end

    # output the list as JSON
    # puts work_ids.to_json

    # create XML document with list of referenced works
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.works {
        xml.comment("The following files were not found in the manuscripts repository")
        not_found.each do |missing|
          xml.missing(id: missing)
        end
        xml.comment("This file was generated with the data repo command 'post -x html'")
        work_ids.each do |work_id, work_info|
          xml.work(id: work_id) {
            work_info.each do |mss|
              xml.mss(id: mss[:mss], certainty: mss[:certainty])
            end
          }
        end
      }
    end

    # convenient debug line
    # puts builder.to_xml

    # write to authority file
    authority_dir = File.join(current_dir, "../..", "source", "authority")
    File.open(File.join(authority_dir, "work_list_generated.xml"), "w") do |f|
      f.write(builder.to_xml)
    end

    puts "generated works list at source/authority/work_list_generated.xml"
    puts "#{not_found.length} missing manuscript files"
  end

end
