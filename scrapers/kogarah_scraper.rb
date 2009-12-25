require 'scraper'

class KogarahScraper < ScraperBase
  def results_as_xml(date)
    f = IO.popen("perl #{File.dirname(__FILE__)}/../non-ruby-scrapers/kogarah.pl --day #{date.day} --month #{date.month} --year #{date.year}")
    f.read
  end
end
