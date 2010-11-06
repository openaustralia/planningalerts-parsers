require 'scraper'

class WaverleyScraper < Scraper
  def applications(date)
    url = "http://epwgate.waverley.nsw.gov.au/ePathway/Production/Web/default.aspx"
    
    # Get the home page
    page = agent.get(url)
    
    # Click the General Enquiries link
    page = page.links[9].click
    
    # Do what clicking the Date Search button does, which is actually
    # Javascript that sets a form parameter and submits it
    page.forms.first["__ctl00_MainBodyContent_mGeneralEnquirySearchControl_mSearchTabStrip_State__"] = "2"
    page = page.forms.first.submit
    
    # Set the date form parameters and submit our search request
    #
    # For some strange reason we have to do this twice, I think the page
    # that's returned the first page has the date fields filled in but
    # I've already spent way to long on this so not checking
    2.times do
      page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$ctl14$mDateFromTextBox$dateTextBox"] = date
      page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$ctl14$mDateToTextBox$dateTextBox"] = date
      page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$mSearchButton"] = "Search"
      page.forms.first["ctl00$MainBodyContent$mGeneralEnquirySearchControl$ctl14$DateSearchRadioGroup"] = "mDateRangeRadioButton"
      page = page.forms.first.submit
    end
    
    page.search("//tr[@class='ContentPanel']|//tr[@class='AlternateContentPanel']").map do |app|
      DevelopmentApplication.new(
        :application_id => app.search("td")[0].inner_text,
        :description => app.search("td")[3].inner_text,
        :address => app.search("td")[2].inner_text,
        :date_received => app.search("td")[1].inner_text,
        :info_url => url,
        :comment_url => email_url("dutyplanner@waverley.nsw.gov.au", app.search("td")[0].inner_text))
    end
  end
end
