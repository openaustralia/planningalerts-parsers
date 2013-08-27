require 'scraperwiki'

class ScraperWikiScraper < Scraper
  def initialize(name, short_name, state)
    # Save the ScraperWiki DBs in /tmp for the moment
    ScraperWiki.config = {:db => File.join(Dir.tmpdir, short_name + '.sqlite')}

    super(name, short_name, state)
  end

  def applications(date)
    begin
      results = ScraperWiki.select "* from swdata where `date_scraped`='#{date}'"
    rescue SqliteMagic::NoSuchTable
      # TODO: Populate the table by running the scraper
      {}
    end

    # TODO: Return results
    {}
  end
end
