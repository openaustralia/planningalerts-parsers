require 'scraper'

# This is using the ePathway system.

class WollongongScraper < Scraper
  def extract_urls_from_page(page)
    content = page.at('table.ContentPanel')
    if content
      content.search('tr')[1..-1].map do |app|
        extract_relative_url(app.search('td')[0])
      end
    else
      []
    end
  end
  
  # Returns a list of URLs for all the applications submitted on the given date
  def urls(date)
    url = "https://epathway.wollongong.nsw.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx"
    page = agent.get(url)
    form = page.forms.first
    form.radiobuttons[1].click
    page = form.submit(form.button_with(:name => /Continue/))
    form = page.forms.first
    # Going to enter a date range
    form.radiobutton_with(:value => /DateRange/).click
    formatted_date = "#{date.day}/#{date.month}/#{date.year}"
    form.field_with(:name => /DateFrom/).value = formatted_date
    form.field_with(:name => /DateTo/).value = formatted_date
    
    page = form.submit(form.button_with(:name => /Search/))
    #p page.parser

    #exit
    page_label = page.at('span#ctl00_MainBodyContent_mPageNumberLabel')
    if page_label.nil?
      # If we can't find the label assume there is only one page of results
      number_of_pages = 1
    elsif page_label.inner_text =~ /Page \d+ of (\d+)/
      number_of_pages = $~[1].to_i
    else
      raise "Unexpected form for number of pages"
    end
    urls = []
    (1..number_of_pages).each do |page_no|
      # Don't refetch the first page
      if page_no > 1
        page = agent.get("https://epathway.wollongong.nsw.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquirySummaryView.aspx?PageNumber=#{page_no}")
      end
      # Get a list of urls on this page
      urls += extract_urls_from_page(page)
    end
    urls
  end
  
  def applications(date)
    urls = urls(date)
    p urls
    puts "There were #{urls.size} urls"
    exit
    []
  end
end