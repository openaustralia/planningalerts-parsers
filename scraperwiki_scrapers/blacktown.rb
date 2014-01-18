require 'mechanize'

# date_range can be either :this_week or :last_week
def applications_search(date_range)
  search_url = "http://apps.blacktown.nsw.gov.au/devonline/"
  # For all the comment url's linking to this page because it has some info about how to comment on an application, etc..
  comment_url = "http://apps.blacktown.nsw.gov.au/devonline/"

  agent = Mechanize.new

  page = agent.get("http://apps.blacktown.nsw.gov.au/devonline/onNotification.cfm?format=list")
    
  # Click the agree button on the form (if necessary)
  form = page.form_with(:name => "Loginform")
  if form
    form.submit(form.button_with(:name => "Agree"))
    page = agent.get("http://apps.blacktown.nsw.gov.au/devonline/onNotification.cfm?format=list")
  end
    
  # Search for applications submitted this week that have not yet been determined


  
  records = []
  page.search("table.DAResults").map do |app|
    description, date_received = nil, nil
    app.search("tr").each do |row|
      heading = row.at("th").inner_html.strip if row.at("th")
      data = row.at("td").inner_html.strip if row.at("td")
      case heading
      when "Lodgement Date"
        # Sometimes this thing is empty. Humph.
        date_received = data if data != ""
      when "Notes"
        description = data
      end
    end
    
    # Sometimes there is an "Addresses" field as well as the "Primary Address" field. For the time being at least
    # I'm going to ignore the "Addresses" field as the one instance where I've seen it it was for two addresses very
    # close to each other.
    
    address = app.at('#GotoMapAddress').inner_html.strip
    # Sometimes (for some reason) the address is empty. In that case the information is completely
    # useless. So, ignore it.
    if address != ""
      record = {
        'council_reference' => app.at("#InspAppNo").inner_html.strip,
        'address' => address + ", NSW",
        'description' => description,
        # We can't link to an individual application so we'll have to link to the search page
        'info_url' => search_url,
        'comment_url' => comment_url,
        "date_scraped" => Date.today.to_s,
      }
      if date_received
        record["date_received"] = Date.parse(date_received).to_s
      end

      if ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? 
        ScraperWiki.save_sqlite(['council_reference'], record)
      else
        puts "Skipping already saved record " + record['council_reference']
      end
    end
  end
end

# Only have the option to search this week and last
applications_search(:this_week)
applications_search(:last_week)
