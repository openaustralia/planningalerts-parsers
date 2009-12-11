require 'scraper'

class BlacktownScraper < Scraper
  
  # date_range can be either :this_week or :last_week
  def applications_search(date_range)
    search_url = "http://www.blacktown.nsw.gov.au/planning-and-development/development-online/development-applications/development-applications_home.cfm"
    # For all the comment url's linking to this page because it has some info about how to comment on an application, etc..
    comment_url = "http://www.blacktown.nsw.gov.au/planning-and-development/development-online/development-online_home.cfm"

    page = agent.get(search_url)
    
    # Click the agree button on the form (if necessary)
    form = page.form_with(:name => "Loginform")
    page = form.submit(form.button_with(:name => "Agree")) if form
    
    # Search for applications submitted this week that have not yet been determined
    form = page.form_with(:name => "DALodgeDate")
    form["DateRange"] = {:this_week => 1, :last_week => 2}[date_range]
    form.radiobutton_with(:value => "undetermined").click
    page = form.submit
    
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
    
      DevelopmentApplication.new(
        :application_id => app.at("#InspAppNo").inner_html.strip,
        :address => app.at('#GotoMapAddress').inner_html.strip + ", " + state,
        :description => description,
        :date_received => date_received,
        # We can't link to an individual application so we'll have to link to the search page
        :info_url => search_url,
        :comment_url => comment_url)
    end
  end
  
  def applications(date)
    # Only have the option to search this week and last but only return applications submitted on the given date
    # or for which the date_received is unknown
    (applications_search(:this_week) + applications_search(:last_week)).find_all{|a| a.date_received == date || a.date_received.nil?}
  end
end
