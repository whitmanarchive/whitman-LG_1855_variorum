class FileType

  # set up variables for the various IIIF locations for whitman
  def set_iiif_paths(additional_path=nil)
    # NOTE: differs from general iiif manifests because of "snippets" subdirectory
    path_from_repo = File.join("output", @options["environment"], "iiif")
    if additional_path
      path_from_repo = File.join(path_from_repo, additional_path)
    end

    iiif_output_path(path_from_repo)
    iiif_output_dir(path_from_repo)
  end

  private

  def iiif_output_dir(path_from_repo)
    @iiif_output_dir = File.join(
      @options["collection_dir"],
      path_from_repo
    )
  end

  def iiif_output_path(path_from_repo)
    @iiif_output_path = File.join(
      @options["data_base"],
      "data",
      @options["collection"],
      path_from_repo
    )
  end

end
