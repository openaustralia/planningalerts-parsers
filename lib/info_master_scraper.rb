require 'scraper'

class InfoMasterScraper < Scraper
  
  def raw_table_values(date, url, rows_to_skip_at_start)
    raw_table(date, url).search('tr')[rows_to_skip_at_start..-1].map {|row| row.search('td')}
  end
  
  # Downloads html table and returns it, ready for the data to be extracted from it
  def raw_table(date, url)
    page = agent.get(url)
    
    # Click the Ok button on the form
    form = page.forms.first
    form.submit(form.button_with(:name => /btnOk/))

    # Get the page again
    page = agent.get(url)

    search_form = page.forms.first
    
    search_form[search_form.field_with(:name => /drDates:txtDay1/).name] = date.day
    search_form[search_form.field_with(:name => /drDates:txtMonth1/).name] = date.month
    search_form[search_form.field_with(:name => /drDates:txtYear1/).name] = date.year
    search_form[search_form.field_with(:name => /drDates:txtDay2/).name] = date.day
    search_form[search_form.field_with(:name => /drDates:txtMonth2/).name] = date.month
    search_form[search_form.field_with(:name => /drDates:txtYear2/).name] = date.year

    # Not sure if that 'span > table' is specific enough to work generally
    search_form.submit(search_form.button_with(:name => /btnSearch/)).search('span > table')
    # TODO: Need to handle what happens when the results span multiple pages. Can this happen?
  end
end

