require 'scraper'

class WarringahScraper < Scraper
  def applications(date)
    # XML feed of the applications submitted in the last 14 days
    url = "http://www.warringah.nsw.gov.au/ePlanning/pages/xc.track/SearchApplication.aspx?o=xml&d=last14days&t=DevApp"
    page = Nokogiri::XML(agent.get(url).body)
    page.search('Application').map do |app|
      data = {
        :info_url => "http://www.warringah.nsw.gov.au/ePlanning/pages/XC.Track/SearchApplication.aspx?id=" + app.at('ApplicationId').inner_text,
        # TODO: I couldn't find any DAs that were open for comment so this the generic one they suggest
        :comment_url => "http://www.warringah.nsw.gov.au/council_now/contact.aspx",
        :application_id => app.at('ReferenceNumber').inner_text,
        :date_received => Date.parse(app.at('LodgementDate').inner_text)
      }
      # Some DAs have good descriptions whilst others just have
      # "<insert here>" so we search for "<insert" and if it's there we
      # use another more basic description
      if app.at('ApplicationDetails').nil? || app.at('ApplicationDetails').inner_text.downcase.index(/<insert/)
        data[:description] = app.at('NatureOfApplication').inner_text
      else
        data[:description] = app.at('ApplicationDetails').inner_text
      end
      data[:addresses] = app.search('Address').map do |address|
        address.at('Line1').inner_text + ", " + address.at('Line2').inner_text
      end
      DevelopmentApplication.new(data)
    end
  end
end
