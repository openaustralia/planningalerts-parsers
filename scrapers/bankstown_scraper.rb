require 'scraper'
require 'open-uri'

#Bankstown expose an xml file already, but it is not compatable with what planningalerts-app expects

class BankstownScraper < Scraper
  # date_range can be any of {today,yesterday,thisweek,lastweek,thismonth,lastmonth}
  def applications_search(date_range)
    base_url = "http://dat.bankstown.nsw.gov.au/pages/xc.track/SearchApplication.aspx"
    search_url = base_url + "?o=xml&d=#{date_range}&k=LodgementDate&t=396"
    #o=xml gives xml results rather than html (o=html)
    #d=thismonth gives results with the date in the current month (also valid are today,yesterday,thisweek,lastweek,thismonth,lastmonth)
    #k=LodgementDate searches for development applications based on date submitted, rather than date determined (k=DeterminationDate)
    #t=396 searches for development applications
    
    begin
      feed_data = open(search_url).read
    rescue Exception => e
      #info_logger.error "Error #{e} while getting data from url #{url}. So, skipping"
      return
    end
    
    feed = Nokogiri::XML(feed_data)
    fetched_applications = feed.search('Application')
    
    fetched_applications.map do |a|
      DevelopmentApplication.new(
        :application_id => a.at('ReferenceNumber').inner_text,
        :address => simplify_whitespace(a.at('Address/Line1').inner_text + ", " + a.at('Address/Line2').inner_text.gsub(/\s*$/, "")), #There was always a Line1 and Line 2 when I checked. I'm not sure if we should check for a Line3, or also work if there is no Line2.
        :description => a.at('ApplicationDetails').inner_text,
        :date_received => a.at('LodgementDate').inner_text.gsub(/T.*$/,""), #dates look like 2010-12-29T00:00:00+10:00
        :info_url => base_url + "?id=" + a.at('ApplicationId').inner_text,
        :comment_url => base_url + "?id=" + a.at('ApplicationId').inner_text, #just use same as info_url
        :on_notice_to => a.at('Determination/Date').nil? || a.at('Determination/Date').inner_text.gsub(/T.*$/,"")) #I think this node of the XML file is only added after the application is determined. So depending on how oftern the scraper is run and if updates are allowed, this may or may not matter.
    end
  end
  
  def applications(date)
    #search in both last and this month listings (that seems to be the largest date span possible)
    (applications_search('thismonth') + applications_search('lastmonth')).find_all{|a| a.date_received == date || a.date_received.nil?}
  end
end