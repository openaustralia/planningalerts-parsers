require 'info_master_scraper'

class TheHillsScraper < InfoMasterScraper
    def get_page(date, url)
    page = agent.get(url)
    
    # Click the Ok button on the form
    form = page.forms_with(:name => /frmMasterView|frmMasterPlan|frmApplicationMaster/).first
    form.submit(form.button_with(:name => /btnOk|Yes|Button1|Agree/))

    # Get the page again
    page = agent.get(url)

    search_form = page.forms_with(:name => /frmMasterView|frmMasterPlan|frmApplicationMaster/).first
    
    if search_form.field_with(:name => /txtFrom/).nil?
      search_form[search_form.field_with(:name => /drDates:txtDay1/).name] = date.day
      search_form[search_form.field_with(:name => /drDates:txtMonth1/).name] = date.month
      search_form[search_form.field_with(:name => /drDates:txtYear1/).name] = date.year
      search_form[search_form.field_with(:name => /drDates:txtDay2/).name] = date.day
      search_form[search_form.field_with(:name => /drDates:txtMonth2/).name] = date.month
      search_form[search_form.field_with(:name => /drDates:txtYear2/).name] = date.year
    else
      search_form[search_form.field_with(:name => /txtFrom/).name] = "#{date.day}/#{date.month}/#{date.year}"
      search_form[search_form.field_with(:name => /txtTo/).name] = "#{date.day}/#{date.month}/#{date.year}"
    end

    #search, and then click the foundDetail link so the descriptions are listed on the search results page
    search_form.submit(search_form.button_with(:name => /btnSearch|SearchBtn/)).link_with(:href => /foundDetail/).click
  end
  
  def applications(date)
    base_path = "http://apps.thehills.nsw.gov.au/masterview/user/ApplicationMaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing (when page=foundDetails):
      #NUM ROAD SUBURB STATE POSTCODE
      #DESCRIPTION TEXT
      #Status: ...
      #Applicant: ...
 
      da = DevelopmentApplication.new(
        :application_id => simplify_whitespace(extract_application_id(values[1])),
        :date_received => extract_date_received(values[2]),
        :address => extract_address_without_state(values[3]),
        :description => extract_description(values[3],1..1)
      )
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end