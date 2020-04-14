require "nokogiri"

class Augmenter

  def initialize
    # get the two files we need and read them in
    current_dir = File.expand_path(File.dirname(__FILE__))
    @repo_dir = File.join(current_dir, "..", "..", "..")

    @log_path = File.join(@repo_dir, "source/tei/ppp.01880.xml")
    @rel_path = File.join(@repo_dir, "source/authority/anc.02134.xml")
    @rep_path = File.join(@repo_dir, "source/authority/changed_lines.xml")
    @log = open_xml(@log_path)
    @rel = open_xml(@rel_path)

    # provide a place to collect lines that were changed
    # (these ids are pre-change)
    @changed_lines = []
  end

  def run
    update_log
    update_relations
    report_changed_lines
  end

  private

  def change_log_lines
    # find all of the elements like <l xml:id="0">
    lines = @log.xpath("//*[name()='lg']/*[name()='l']")
    lines.each do |line|
      orig_id = line["xml:id"]
      num = get_id_num(orig_id)
      if num
        # augment
        new_num = num.to_i + 1
        line["xml:id"] = "l#{new_num}"
        @changed_lines << num
      end
    end
    puts "changed #{lines.length} lines in Leaves of Grass"
  end

  def change_rel_lines
    lines = @rel.xpath("//*[name()='link']")
    lines.each do |line|
      t_path, t_id, trailing = line["target"].split("#")
      if t_path == "ppp.01880.xml"
        # puts trailing
        num = get_id_num(t_id)
        if num
          new_num = num.to_i + 1
          line["target"] = "#{t_path}#l#{new_num} ##{trailing}"
          @changed_lines << num
        end
      end
    end
    puts "changed #{lines.length} lines in relations file"
  end

  def get_id_num(id)
    id[/^l(\d{0,4}) ?$/,1]
  end

  def open_xml(file)
    doc = File.open(file) do |f|
      Nokogiri::XML(f, &:noblanks)
    end
  end

  def report_changed_lines
    # deduplicate, sort, and then write as XML
    lines = @changed_lines.uniq.map(&:to_i).sort

    builder = Nokogiri::XML::Builder.new do |xml|
      xml.changed_lines {
        lines.each do |line|
          xml.line line
        end
      }
    end

    write_file(@rep_path, builder, 2)
  end

  def update_log
    change_log_lines
    write_file(@log_path, @log, 3)
  end

  def update_relations
    change_rel_lines
    write_file(@rel_path, @rel, 4)
  end

  def write_file(path, contents, indent)
    File.open(path, "w") { |f| f.write(contents.to_xml(indent: indent)) }
  end

end
