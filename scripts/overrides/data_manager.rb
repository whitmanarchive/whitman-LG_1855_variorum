require_relative "work_list.rb"

class Datura::DataManager

  def pre_batch_processing
    # generate a list of files which contain works
    generate_work_list()
  end

end
