# Ballina Shire Council DAs Online
# (ICON Software Solutions PlanningXchange)
# Sourced from http://http://da.ballina.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx?ss=s
# Formatted for http://www.planningalerts.org.au/
require 'net/http'

class BallinaScraper < Scraper

  def parse_application(item)
    # RSS title appears to be the council reference
    rss_title = item.xpath('title').first.text.split '-'
    council_reference = rss_title[0].strip

    
    # DA = Development Application
    # CA = Complying Development
    # CC = Construction Certificate


    if item.xpath('category').first.text.strip != "Development Applications"
      return
    end

    # RSS description appears to be the address followed by the actual description
    rss_description = item.xpath('description').first.text.split /\./ 
    #, 2
    address = rss_description[0].strip
    description = rss_description[1].strip # TODO strip tags
  
    info_url = item.xpath('link').first.text.strip
  
    date_received = Date.strptime(item.xpath('pubDate').first.text)
    
    DevelopmentApplication.new({
      application_id: council_reference,
      address: address,
      description: description,
      info_url: info_url,
      comment_url: 'mailto:council@ballina.nsw.gov.au',
      date_received: date_received
    })
  end

  def applications(date)
    terms_url = 'http://da.ballina.nsw.gov.au/Common/User/Terms.aspx'
    rss_feed = URI.parse('http://da.ballina.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx?o=rss&d=last14days&t=10,18')

    # accept_terms(terms_url, cookie_file)

    # Download and parse RSS feed (last 14 days of applications)
    rss_response = Net::HTTP.get_response(rss_feed).body

    rss = Nokogiri::XML(rss_response)
    rss.xpath('//channel/item').collect {|item| parse_application(item)}.compact!
  end
end
