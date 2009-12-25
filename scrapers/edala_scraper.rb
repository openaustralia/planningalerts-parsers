require 'scraper'

class EDALAScraper < ScraperBase
  def results_as_xml(date)
    ENV['REQUEST_METHOD'] = 'GET'
    ENV['QUERY_STRING'] = "year=#{date.year}&month=#{date.month}&day=#{date.day}"
    ENV['PATH_INFO'] = "?" + ENV['QUERY_STRING']
    ENV['PATH_TRANSLATED'] = ENV['PATH_INFO']
    ENV['SCRIPT_FILENAME'] = File.expand_path("#{File.dirname(__FILE__)}/../non-ruby-scrapers/edala.php")
    f = IO.popen("php-cgi -d short_open_tag=0 -d cgi.force_redirect=0 -f #{ENV['SCRIPT_FILENAME']}")
    f.read
  end
end
