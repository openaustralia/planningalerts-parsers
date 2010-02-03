require 'info_master_scraper'

# The Sutherland Shire site looks like the InfoMaster system but is yet again very different from the others.
# Most obviously on the search page the date is one field rather than three.
class SutherlandScraper < InfoMasterScraper
  
  # Override implementation of get_table from superclass
  def get_page(date, url)
    page = agent.get(url)
    
    # Click the Ok button on the form
    form = page.forms.first
    #p page.forms
    page = form.submit(form.button_with(:name => /btnOk|Yes|Button1|Agree/))
    #p page.parser
    
    form = page.forms.first
    
    formatted_date = "#{date.day}/#{date.month}/#{date.year}"
    form[form.field_with(:name => /txtFrom/).name] = formatted_date
    form[form.field_with(:name => /txtTo/).name] = formatted_date
    
    page = form.submit(form.button_with(:name => /Search/))
  end
  
  def applications(date)
    url = "https://remote.ssc.nsw.gov.au/datracking"
    raw_table_values(date, url, 1, 'span#_ctl2_lblData').map do |values|
      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :description => extract_description(values[3], 1..-2),
        :address => extract_address(values[3]),
        :date_received => extract_date_received(values[2]),
        # Don't think there's a URL that gives the result of the search. There are some very weird things
        # with authentication on this app. So, just going to point to the generic DA tracker login page
        :info_url => url,
        :comment_url => url)
      da
    end
  end
end