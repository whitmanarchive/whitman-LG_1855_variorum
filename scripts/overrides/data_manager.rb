require_relative "work_list.rb"
require_relative "manifest_log.rb"
# require_relative "manifest_snippets.rb"

class Datura::DataManager

  def pre_batch_processing
    # generate a list of files which contain works
    generate_work_list()
    # generate the leaves of grass iiif presentation manifest
    ManifestLog.generate(@options)
    # generate several dozen iiif presentation manifests
    # that represent individual page comparisons
    ManifestSnippets.generate(@options)
  end

end
