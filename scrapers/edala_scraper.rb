require 'scraper'

class EDALAScraper < ScraperBase
  def results_as_xml(date)
    ENV['QUERY_STRING'] = "year=#{date.year}&month=#{date.month}&day=#{date.day}"
    ENV['PATH_INFO'] = "/edala?" + ENV['QUERY_STRING']
    ENV['PATH_TRANSLATED'] = ENV['PATH_INFO']
    f = IO.popen("php-cgi -d short_open_tag=0 -f #{File.dirname(__FILE__)}/../non-ruby-scrapers/edala.php")
    f.read
  end
end
