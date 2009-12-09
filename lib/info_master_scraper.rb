require 'scraper'
require 'htmlentities'

class InfoMasterScraper < Scraper
  def raw_table_values(date, url, rows_to_skip_at_start, table_search = 'span > table', rows_to_skip_at_end = 0)
    range = rows_to_skip_at_start..(-1-rows_to_skip_at_end)
    raw_table(date, url, table_search).search('tr')[range].map {|row| row.search('td')}
  end
  
  # Downloads html table and returns it, ready for the data to be extracted from it
  # Not sure if that 'span > table' is specific enough to work generally for finding the needed table
  def raw_table(date, url, table_search)
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

    search_form.submit(search_form.button_with(:name => /btnSearch/)).search(table_search)
    # TODO: Need to handle what happens when the results span multiple pages. Can this happen?
  end

  def extract_date_received(html)
    inner(html)
  end
  
  def extract_application_id(html)
    inner(html)
  end
  
  def extract_address(html, lines = 0..0)
    (split_lines(html)[lines] + [state]).join("\n")
  end
  
  def extract_description(html, lines = -1..-1)
    split_lines(html)[lines].join("\n").strip
  end
  
  def inner(html)
    html.inner_html.strip
  end
  
  def convert_html_entities(str)
    HTMLEntities.new.decode(str)
  end
  
  def split_lines(html)
    html.inner_html.split('<br>').map{|s| convert_html_entities(strip_html_tags(s)).strip.gsub("\r", "\n")}
  end
  
  def strip_html_tags(str)
    str.gsub(/<\/?[^>]*>/, "")
  end
end

