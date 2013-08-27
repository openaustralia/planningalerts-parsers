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

    results.map do |a|
      DevelopmentApplication.new(
        :application_id => a["council_reference"],
        :description => a["description"],
        :address => a["address"],
        :on_notice_from => a["on_notice_from"],
        :on_notice_to => a["on_notice_to"],
        :date_received => a["date_received"],
        :info_url => a["info_url"],
        :comment_url => a["comment_url"])
    end
  end
end
