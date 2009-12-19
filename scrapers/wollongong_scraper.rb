require 'scraper'

# This is using the ePathway system.

class WollongongScraper < Scraper
  def extract_urls_from_page(page)
    page.at('table.ContentPanel').search('tr')[1..-1].map do |app|
      extract_relative_url(app.search('td')[0])
    end
  end
  
  def applications(date)
    url = "https://epathway.wollongong.nsw.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx"
    page = agent.get(url)
    form = page.forms.first
    form.radiobuttons.first.click
    page = form.submit(form.button_with(:name => /Continue/))
    if page.at('span#ctl00_MainBodyContent_mPageNumberLabel').inner_text =~ /Page \d+ of (\d+)/
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
    p urls
    puts "There were #{urls.size} urls"
    exit
    []
  end
end