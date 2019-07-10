require "nokogiri"

class Datura::DataManager

  def add_to_work_ids(ref, obj)
    if @work_ids.key?(ref)
      @work_ids[ref] << obj
    else
      @work_ids[ref] = [obj]
    end
  end

  def get_files_to_search
    mss_filepath = File.join(
      @options["collection_dir"], "source", "authority", "files_with_works.txt"
    )
    File.readlines(mss_filepath).map { |f| f.strip }
  end

  def locate_file(file)
    types = {
      "whitman-manuscripts" => "mss",
      "whitman-marginalia" => "marg",
      "whitman-notebooks" => "nb"
    }
    # scour the directories looking for the matching file
    types.each do |repo, type|
      tei_dir = File.join(@options["collection_dir"], "..", repo, "source", "tei")
      file_path = File.join(tei_dir, file)
      if File.file?(file_path)
        return [ file_path, type ]
      end
    end
    # if you made it this far, then the file is missing!
    @not_found << file
    [ nil, nil ]
  end

  def pre_batch_processing
    # can access @files array
    current_dir = File.dirname(__FILE__)
    # create a work id object which will track files that contain a work
    # create a not found object which will hold those files which were not located
    @work_ids = {}
    @not_found = []

    files_to_search = get_files_to_search

    files_to_search.each do |file|
      path, type = locate_file(file)
      next if path.nil?

      xml = File.open(path) { |f| Nokogiri::XML(f).remove_namespaces! }
      works = xml.xpath("/TEI/relations/work")
      works.each do |work|
        ref = work["ref"]
        certainty = work["certainty"] || work["cert"] || "not marked"
        if ref
          obj = { id: file, certainty: certainty, type: type }
          add_to_work_ids(ref, obj)
        else
          puts "No reference work id found in #{file}"
        end
      end
    end

    # output the list as JSON
    # puts work_ids.to_json

    # create XML document with list of referenced works
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.works {
        xml.files {
          xml.comment("The following files were not found in the manuscripts repository")
          @not_found.each do |missing|
            xml.missing(id: missing)
          end
        }
        xml.comment("This file was generated with the data repo command 'post -x html'")
        @work_ids.each do |work_id, work_info|
          xml.work(id: work_id) {
            work_info.each do |info|
              xml.item(id: info[:id], type: info[:type], certainty: info[:certainty])
            end
          }
        end
      }
    end

    # convenient debug line
    # puts builder.to_xml

    # write to authority file
    authority_dir = File.join(@options["collection_dir"], "source", "authority")
    File.open(File.join(authority_dir, "work_list_generated.xml"), "w") do |f|
      f.write(builder.to_xml)
    end

    puts "generated works list at source/authority/work_list_generated.xml"
    puts "#{@not_found.length} missing manuscript files"
  end

end
