require 'scraper'

class WaverleyScraper < Scraper
  def applications(date)
    url = "http://epwgate.waverley.nsw.gov.au/ePathway/Production/Web/default.aspx"
    new_url = "https://epwgate.waverley.nsw.gov.au/DA_Tracking/Modules/Applicationmaster/Default.aspx?page=disc"
    
    # Get the home page
    page = agent.get(url)
    
    # Click the General Enquiries link
    page = page.link_with(:text => "Enquiry Lists").click

    # Set the date form parameters and submit our search request
    page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$mTabControl$ctl04$mToDatePicker$dateTextBox"] = date
    page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$mTabControl$ctl04$mFromDatePicker$dateTextBox"] = date
    page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$mSearchButton"] = "Search"
    page = page.forms.first.submit
    
    page.search("//tr[@class='ContentPanel']|//tr[@class='AlternateContentPanel']").map do |app|
      DevelopmentApplication.new(
        :application_id => app.search("td")[0].inner_text,
        :description => app.search("td")[3].inner_text,
        :address => app.search("td")[2].inner_text,
        :date_received => app.search("td")[1].inner_text,
        :info_url => new_url,
        :comment_url => email_url("dutyplanner@waverley.nsw.gov.au", app.search("td")[0].inner_text))
    end
  end
end
