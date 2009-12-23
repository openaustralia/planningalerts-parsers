require 'scraper'

class EDALAScraper < ScraperBase
  def results_as_xml(date)
    f = IO.popen("php -d short_open_tag=0 #{File.dirname(__FILE__)}/../non-ruby-scrapers/edala.php")
    f.read
  end
end
