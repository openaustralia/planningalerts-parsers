require 'scraper'

class InfoMasterScraper < Scraper
  def raw_table_values(date, url, rows_to_skip_at_start, table_search = 'span > table', rows_to_skip_at_end = 0)
    range = rows_to_skip_at_start..(-1-rows_to_skip_at_end)
    rows = get_page(date, url).search(table_search).search('tr')
    return [] if rows.nil? || rows.size < rows_to_skip_at_start
    values = rows[range].map {|row| row.search('td')}
    values.delete_if {|row| row.inner_text =~ /\A\s*\Z/} #some InfoMaster installations insert a blank every second row, we can just remove these
    first_row = values.first
    return [] if first_row.nil? || first_row.first.inner_text =~ /no applications found/i || first_row.first.inner_text =~ /no results found/i || first_row.first.inner_text =~ /no records matching/i
    values
  end
  
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

    search_form.submit(search_form.button_with(:name => /btnSearch|SearchBtn/))
    # TODO: Need to handle what happens when the results span multiple pages. Can this happen?
  end
  
  def extract_date_received(html)
    inner(html)
  end
  
  def extract_application_id(html)
    simplify_whitespace(inner(html))
  end
  
  def extract_address_without_state(html, lines = 0..0)
    simplify_whitespace(split_lines(html)[lines].join(" "))
  end
  
  def extract_address(html, lines = 0..0)
    extract_address_without_state(html, lines) + ", " + state
  end
  
  def extract_description(html, lines = -1..-1)
    split_lines(html)[lines].join("\n").strip
  end
  
  def extract_info_url(html)
    html.at('a').attributes['href']
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

