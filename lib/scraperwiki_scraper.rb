require 'open-uri'

class ScraperWikiScraper < Scraper
  def initialize(name, short_name, state, scraperwiki_name)
    super(name, short_name, state)
    @scraperwiki_name = scraperwiki_name
  end
  
  def applications(date)
    # TODO: Grab the metadata from scraperwiki and compare it to the name, short_name and state above
    # It appears that this isn't currently possible through the external API.
    data = open("https://api.scraperwiki.com/api/1.0/datastore/sqlite?format=jsondict&name=#{@scraperwiki_name}&query=select%20*%20from%20swdata%20where%20%60date_scraped%60%3D'#{date}'") do |f|
      JSON.parse(f.read)
    end
    data.map do |a|
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
