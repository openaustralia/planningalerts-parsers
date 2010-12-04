require 'scraper'
require 'open-uri'
require 'json'

class ScraperWikiScraper < Scraper
  def initialize(name, short_name, state, scraperwiki_name)
    super(name, short_name, state)
    @scraperwiki_name = scraperwiki_name
  end
  
  def applications(date)
    # TODO: Grab the metadata from scraperwiki and compare it to the name, short_name and state above
    # It appears that this isn't currently possible through the external API.
    # http://api.scraperwiki.com/api/1.0/datastore/getdata?format=json&name=blue-mountains-city-council-development-applicatio
    data = open("http://api.scraperwiki.com/api/1.0/datastore/getdata?format=json&name=#{@scraperwiki_name}") do |f|
      JSON.parse(f.read)
    end
    data.map do |a|
      DevelopmentApplication.new(
        :application_id => a["council_reference"],
        :description => a["description"],
        :address => a["address"], 
        :on_notice_from => a["on_notice_from"],
        :on_notice_to => a["on_notice_to"],
        :info_url => a["info_url"],
        :comment_url => a["comment_url"])
    end
  end
end
