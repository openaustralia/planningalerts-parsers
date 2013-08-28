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

  # The main url for the planning system which can be reached directly without getting a stupid session timed out error
  def enquiry_url
    "http://epathway.wollongong.nsw.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquiryLists.aspx"
  end

  # Returns a list of URLs for all the applications submitted on the given date
  def urls(date)
    # Get the main page and ask for the list of DAs on exhibition
    page = agent.get(enquiry_url)
    form = page.forms.first
    form.radiobuttons[0].click
    page = form.submit(form.button_with(:value => /Next/))

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
        page = agent.get("http://epathway.wollongong.nsw.gov.au/ePathway/Production/Web/GeneralEnquiry/EnquirySummaryView.aspx?PageNumber=#{page_no}")
      end
      # Get a list of urls on this page
      urls += extract_urls_from_page(page)
    end
    urls
  end

  def extract_field(field, label)
    raise "unexpected form" unless field.search('td')[0].inner_text == label
    field.search('td')[1].inner_text.strip
  end

  def applications(date)
    urls = urls(date)
    urls.map do |url|
      # Get application page with a referrer or we get an error page
      page = agent.get(url, [], URI.parse(enquiry_url))

      table = page.search('table#ctl00_MainBodyContent_DynamicTable > tr')[0].search('td')[0].search('table')[2]

      date_received = extract_field(table.search('tr')[0], "Lodgement Date")
      application_id = extract_field(table.search('tr')[2], "Application Number")
      description = simplify_whitespace(extract_field(table.search('tr')[3], "Proposal"))

      table = page.search('table#ctl00_MainBodyContent_DynamicTable > tr')[2].search('td')[0].search('table')[2]
      rows = table.search('tr')[0].search('table > tr')[1..-1]
      if rows
        addresses = rows.map do |a|
          a.search('td')[0].inner_text.strip.gsub('  ', ' ')
        end
      else
        addresses = []
      end
      DevelopmentApplication.new(
        :date_received => date_received,
        :application_id => application_id,
        :description => description,
        :addresses => addresses,
        :info_url => enquiry_url,
        :comment_url => enquiry_url)
    end
  end
end
