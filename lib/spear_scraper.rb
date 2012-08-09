class SPEARScraper < Scraper
  def initialize(name, short_name, state, web_form_name)
    super(name, short_name, state)
    @web_form_name = web_form_name
  end
  
  # Extracts all the data on a single page of results
  def extract_page_data(page)
    apps = []
    # Skip first two row (header) and last row (page navigation)
    page.at('div#list table').search('tr')[2..-2].each do |row|
      values = row.search('td')
      
      # Type appears to be either something like "Certification of a Plan" or "Planning Permit and Certification"
      # I think we need to look in detail at the application to get the description
      # TODO: Figure out whether we should ignore "Certification of a Plan"
      #type = values[3].inner_html.strip
      #status = values[4].inner_html.strip
      # I'm going to take a punt here on what the correct thing to do is - I think if there is a link available to
      # the individual planning application that means that it's something that requires deliberation and so interesting.
      # I'm going to assume that everything else is purely "procedural" and should not be recorded here

      # If there is a link on the address record this development application
      if values[0].at('a')
        da = DevelopmentApplication.new(
          # This is the "Council ref". We could alternatively use the SPEAR Ref #. Which is "correct"?
          :application_id => values[2].inner_html.strip,
          :address => values[0].at('a').inner_html.strip,
          :date_received => values[10].inner_html.strip,
          :info_url => page.uri + URI.parse(values[0].at('a').attributes['href']))
        # TODO: Setting the comment URL to be the same as the info URL because I don't know what else to
        # do for the time being
        da.comment_url = da.info_url
        apps << da
      end
    end
    apps
  end
  
  
  # Get a description of the application extracted from the more detailed information page (at info_url)
  def extract_description(info_url)
    page = agent.get(info_url)
    # The horrible thing about this page is they use tables for layout. Well done!
    # Also I think the "Intended use" bit looks like the most useful. So, we'll use that for the description
    page.at('div#bodypadding table').search('table')[1].search('tr').find do |row|
      # <th> tag contains the name of the field, <td> tag contains its value
      row.at('th') && row.at('th').inner_text.strip == "Intended use"
    end.at('td').inner_text.strip
  end
  
  def applications(date)
    url = "http://www.spear.land.vic.gov.au/spear/publicSearch/Search.do"

    page = agent.get(url)
    form = page.forms.first
    # TODO: Is there a more sensible way to pick the item in the drop-down?
    form.field_with(:name => "councilName").options.find{|o| o.text == @web_form_name}.click
    page = form.submit
    
    applications = []
    begin
      applications += extract_page_data(page).find_all{|r| r.date_received == date}
      next_link = page.link_with(:text => /next/)
      page = next_link.click if next_link
    end until next_link.nil?

    # Next we get more detailed information by going to each page of each individual application
    applications.each do |a|
      a.description = extract_description(a.info_url)
    end
    applications
  end
end
