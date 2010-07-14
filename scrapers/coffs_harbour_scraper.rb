require 'info_master_scraper'

class CoffsHarbourScraper < InfoMasterScraper
    #we must overide InfoMasterScraper's get_page to do the login and to workaround their buggy search
    def get_page(date, url)
    page = agent.get(url)
    
    # Click the Ok button on the form
    form = page.forms_with(:name => /frmMasterView|frmMasterPlan|frmApplicationMaster/).first
    form.submit(form.button_with(:name => /btnOk|Yes|Button1|Agree/))

    # Get the page again
    page = agent.get(url)
    
    # Login
    login_form = page.forms_with(:name => /frmMasterView|frmMasterPlan|frmApplicationMaster/).first
    login_form[login_form.field_with(:name => /txtName/).name] = 'dmwwupbnhtccut@mailinator.com'
    login_form[login_form.field_with(:name => /txtPWD/).name] = 'password'
    login_form.submit(login_form.button_with(:name => /LoginBtn/))
    
    # Get the page again
    page = agent.get(url)

    # Do a search by dates
    search_form = page.forms_with(:name => /frmMasterView|frmMasterPlan|frmApplicationMaster/).first
    
    search_form[search_form.field_with(:name => /drDates:txtDay1/).name] = date.day
    search_form[search_form.field_with(:name => /drDates:txtMonth1/).name] = date.month
    search_form[search_form.field_with(:name => /drDates:txtYear1/).name] = date.year
    search_form[search_form.field_with(:name => /drDates:txtDay2/).name] = date.day + 1 #doesn't return any results if you have day1 and day2 the same (with the same month and year). also it seems to not return day2+1 dates, so we haven't needed to filtered out the results with the extra date.
    search_form[search_form.field_with(:name => /drDates:txtMonth2/).name] = date.month
    search_form[search_form.field_with(:name => /drDates:txtYear2/).name] = date.year

    search_form.submit(search_form.button_with(:name => /btnSearch/))
    # TODO: Need to handle what happens when the results span multiple pages. Can this happen?
  end
  
  def applications(date)
    base_path = "http://datracking.coffsharbour.nsw.gov.au/DATracking/modules/applicationmaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing:
      #NUM ROAD, SUBURB
      #DESCRIPTION TEXT
      
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address(values[3]),
        :description => extract_description(values[3])
      )
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end