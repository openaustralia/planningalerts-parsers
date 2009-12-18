require 'scraper'

# TODO: Directly output the information which is already geocoded

class MosmanScraper < Scraper
  def applications(date)
    # GeoRSS feed of the applications submitted in the last 14 days
    url = "http://portal.mosman.nsw.gov.au/pages/xc.track/RSS.aspx?feed=lodgelast14"
    page = Nokogiri::XML(agent.get(url).body)
    page.search('item').map do |app|
      DevelopmentApplication.new(
        :address => app.at('title').inner_text.strip + ", " + planning_authority_short_name + ", " + state,
        :info_url => app.at('link').inner_text.strip,
        # Giving feedback on the application is on a tab off the application page. Can't seem to link
        # to it directly
        :comment_url => app.at('link').inner_text.strip,
        :description => app.at('description').inner_text.split(' - ')[1..-1].join(' - ').strip,
        :application_id => app.at('description').inner_text.split(' - ')[0].strip,
        :date_received => app.at('pubDate').inner_text)
    end
  end
end