require 'scraper'

class BlacktownScraper < Scraper
  def applications(date)
    url = "http://www.blacktown.nsw.gov.au/planning-and-development/development-online/development-applications/development-applications_home.cfm"
    page = agent.get(url)
    
    # Click the agree button on the form
    form = page.form_with(:name => "Loginform")
    page = form.submit(form.button_with(:name => "Agree"))
    
    # Search for applications submitted this week that have not yet been determined
    form = page.form_with(:name => "DALodgeDate")
    form["DateRange"] = 1
    form.radiobutton_with(:value => "undetermined").click
    page = form.submit
    
    app = page.at("table.DAResults")
    description, date_received = nil, nil
    app.search("tr").each do |row|
      heading = row.at("th").inner_html.strip if row.at("th")
      data = row.at("td").inner_html.strip if row.at("td")
      case heading
      when "Lodgement Date"
        date_received = data
      when "Notes"
        description = data
      end
    end
    
    # Sometimes there is an "Addresses" field as well as the "Primary Address" field. For the time being at least
    # I'm going to ignore the "Addresses" field as the one instance where I've seen it it was for two addresses very
    # close to each other.
    
    application_id = app.at("#InspAppNo").inner_html.strip
    address = app.at('#GotoMapAddress').inner_html.strip
    puts "Application_id: #{application_id}"
    puts "Description: #{description}"
    puts "Address: #{address}"
    puts "Date receive: #{date_received}"
    exit
    []
  end
end
