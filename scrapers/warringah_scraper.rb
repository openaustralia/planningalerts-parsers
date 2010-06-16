require 'scraper'

class WarringahScraper < Scraper
  def applications(date)
    # XML feed of the applications submitted in the last 14 days
    url = "http://www.warringah.nsw.gov.au/ePlanning/pages/xc.track/SearchApplication.aspx?o=xml&d=last14days&t=DevApp"
    page = Nokogiri::XML(agent.get(url).body)
    applications = []
    page.search('Application').each do |app|
      data = {
        :info_url => "http://www.warringah.nsw.gov.au/ePlanning/pages/XC.Track/SearchApplication.aspx?id=" + app.at('ApplicationId').inner_text,
        # TODO: I couldn't find any DAs that were open for comment so this the generic one they suggest
        :comment_url => "http://www.warringah.nsw.gov.au/council_now/contact.aspx",
        # Yeesh, crappy description provided by the council
        :description => app.at('NatureOfApplication').inner_text + " - " + app.at('ApplicationDetails').inner_text,
        :application_id => app.at('ReferenceNumber').inner_text,
        :date_received => Date.parse(app.at('LodgementDate').inner_text)
      }
      # For applications for which there are multiple addresses simply record them as separate applications
      app.search('Address').each do |address|
        applications << DevelopmentApplication.new(
          data.merge(:address => address.at('Line1').inner_text + ", " + address.at('Line2').inner_text))
      end
    end
    applications
  end
end
