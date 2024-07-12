require_relative "work_list.rb"

class Datura::DataManager

  def post_batch_processing
    if @options["environment"] == "production" && options["transform_types"].include?("html")
      puts
      puts "Copying generated HTML to paths used by Apache:".cyan
      FileUtils.cp("output/production/html/ppp.01879.html", "source/assets/reviews.html", verbose: true);
      FileUtils.cp("output/production/html/ppp.01880.html", "source/assets/main.html", verbose: true);
      puts
    end
  end

  def pre_batch_processing
    # generate a list of files which contain works
    generate_work_list()
  end

end
