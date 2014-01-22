require 'logger'
require 'info_master_scraper'

class HornsbyScraper < InfoMasterScraper
  def raw_table_values(date, url, rows_to_skip_at_start, table_search = 'span > table', rows_to_skip_at_end = 0)
    range = rows_to_skip_at_start..(-1-rows_to_skip_at_end)
    page = get_page(date, url)

    rows = page.search('table .rgRow')

    return [] if rows.nil? || rows.size < rows_to_skip_at_start
    values = rows[range].map {|row| row.search('td')}
    values.delete_if {|row| row.inner_text =~ /\A\s*\Z/} #some InfoMaster installations insert a blank every second row, we can just remove these
    first_row = values.first
    return [] if first_row.nil? || first_row.first.inner_text =~ /no applications found/i || first_row.first.inner_text =~ /no results found/i || first_row.first.inner_text =~ /no records matching/i
    values
  end

  def get_page(date, url)
    agent.log = Logger.new(STDOUT)
    page = agent.get(url)
    # Click the Ok button on the form
    form = page.forms_with(:name => /aspnetForm/).first
    form.checkbox.click 
    submit_button = form.button_with(:value => /Agree/)
    form.submit(submit_button)

    # Get the page again
    agent.get("http://hsconline.hornsby.nsw.gov.au/appenquiry/modules/applicationmaster/default.aspx?page=found&1=#{date.strftime("01/%m/%Y")}&2=#{date.strftime("%d/%m/%Y")}")
  end

  def applications(date)
    base_path = "http://hsconline.hornsby.nsw.gov.au/appenquiry/modules/applicationmaster/"
    base_url = base_path + "default.aspx"
    raw_table_values(date, "#{base_url}?page=search", 1).map do |values|
      
      #Example description column in applications listing:
      #NUM ROAD SUBURB STATE POSTCODE
      #DESCRIPTION TEXT
      #Applicant: ...

      da = DevelopmentApplication.new(
        :application_id => extract_application_id(values[1]),
        :date_received => extract_date_received(values[2]),
        :address => extract_address_without_state(values[3]),
        :description => extract_description(values[3],1..1)
      )
      
      application_number = da.application_id
      application_year=""
      
      da.info_url = URI.escape(base_path + extract_info_url(values[0]))
      da.comment_url = da.info_url
      da
    end
  end
end