require "nokogiri"

module Helpers

  def get_current_path
    # get the two files we need and read them in
    current_dir = File.expand_path(File.dirname(__FILE__))
    @repo_dir = File.join(current_dir, "..", "..", "..")
  end

  def open_xml(file)
    doc = File.open(file) do |f|
      Nokogiri::XML(f, &:noblanks)
    end
  end

  def write_xml_file(path, contents, indent)
    File.open(path, "w") { |f| f.write(contents.to_xml(indent: indent)) }
  end

end
