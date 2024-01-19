require "nokogiri"

class Datura::DataManager

  def add_to_work_ids(ref, obj)
    if @work_ids.key?(ref)
      @work_ids[ref] << obj
    else
      @work_ids[ref] = [obj]
    end
  end

  def generate_work_list()
    # can access @files array
    # create a work id object which will track files that contain a work
    # create a not found object which will hold those files which were not located
    @work_ids = {}
    @not_found = []

    files_to_search = get_files_to_search

    files_to_search.each do |file|
      path, type = locate_file(file)
      next if path.nil?

      xml = File.open(path) { |f| Nokogiri::XML(f).remove_namespaces! }
      works = xml.xpath("/TEI//notesStmt/note[@type='work_relations']")
      works.each do |work|
        ref = work["target"]
        certainty = work["certainty"] || work["cert"] || "not_marked"
        if ref
          obj = { id: file, certainty: certainty, type: type }
          add_to_work_ids(ref, obj)
        else
          puts "No reference work id found in #{file}"
        end
      end
    end

    # deduplicate the lists
    @work_ids.each do |work, files|
      # this deduplicates anything that's an exact match
      files = files.uniq
      files = select_highest_certainty_file(files)
      files = files.sort_by { |file| [ file[:certainty], file[:id] ] }
      @work_ids[work] = files
    end


    # output the list as JSON
    # puts work_ids.to_json
    # create XML document with list of referenced works
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.works {
        xml.files {
          xml.comment("The following files were not found in any of the cocoon tei locations")
          @not_found.each do |missing|
            xml.missing(id: missing)
          end
        }
        xml.comment("This file was generated with the data repo command 'bundle exec post -x html'")
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

    puts @options["collection_dir"]
    # write to authority file
    authority_dir = File.join(@options["collection_dir"], "source", "authority")
    File.open(File.join(authority_dir, "work_list_generated.xml"), "w") do |f|
      f.write(builder.to_xml)
    end

    puts "generated works list at source/authority/work_list_generated.xml"
    puts "#{@not_found.length} missing cocoon tei files"
  end

  def get_files_to_search
    mss_filepath = File.join(
      @options["collection_dir"], "source", "authority", "files_with_works.txt"
    )
    File.readlines(mss_filepath).map { |f| f.strip }
  end

  def locate_file(file)
    data_root = File.join(@options["collection_dir"], "..")
    types = {
      "marg" => "whitman-marginalia/source/tei",
      "mss" => "whitman-manuscripts/source/tei",
      "nb" => "whitman-notebooks/source/tei"
    }
    # scour the directories looking for the matching file
    types.each do |type, location|
      tei_dir = File.join(data_root, location)
      file_path = File.join(tei_dir, file)
      if File.file?(file_path)
        return [ file_path, type ]
      end
    end
    # if you made it this far, then the file is missing!
    @not_found << file
    [ nil, nil ]
  end

  def select_highest_certainty_file(files)
    # absolute > high > low > not_marked
    # if there is something higher up the food chain, then delete everything else
    ids = files.group_by { |f| f[:id] }
    ids.each do |id, id_group|
      if id_group.length > 1
        if id_group.select { |id| id[:certainty] == "absolute" }.length > 0
          files.delete_if { |file| file[:id] == id && file[:certainty] != "absolute" }
        elsif id_group.select { |id| id[:certainty] == "high" }.length > 0
          files.delete_if { |file| file[:id] == id && file[:certainty] != "high" }
        elsif id_group.select { |id| id[:certainty] == "low" }.length > 0
          files.delete_if { |file| file[:id] == id && file[:certainty] != "low" }
        end
      end
    end
    files
  end

end
