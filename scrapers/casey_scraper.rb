$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'scraper'
require 'planning_authority_results'

# A development application in the Victorian SPEAR system (https://www.landexchange.vic.gov.au/spear/)
# We want to track a little extra information here
class SPEARDevelopmentApplication < DevelopmentApplication
  add_attributes :spear_id
end

class CaseyScraper < Scraper
  @planning_authority_name = "Casey City Council"
  @planning_authority_short_name = "Casey"

  # Extracts all the data on a single page of results
  def extract_page_data(page, results)
    # Skip first row (header) and last row (page navigation)
    page.at('div#list table').search('tr')[1..-2].each do |row|
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
        da = SPEARDevelopmentApplication.new(
          # This is the "Council ref". We could alternatively use the SPEAR Ref #. Which is correct?
          :application_id => values[2].inner_html.strip,
          :address => values[0].at('a').inner_html.strip,
          :date_received => values[10].inner_html.strip,
          :spear_id => values[8].inner_html.strip,
          :info_url => page.uri + URI.parse(values[0].at('a').attributes['href']))
        # TODO: Need to figure out comment_url and description
        results << da
      end
    end
  end
  
  def applications
    results = PlanningAuthorityResults.new(:name => self.class.planning_authority_name, :short_name => self.class.planning_authority_short_name)
    url = "http://www.landexchange.vic.gov.au/spear/publicSearch/Search.do"

    page = agent.get(url)
    form = page.forms.first
    # TODO: Is there a more sensible way to pick the item in the drop-down?
    form.field_with(:name => "councilName").options.find{|o| o.text == "Casey City Council"}.click
    page = form.submit
    
    begin
      extract_page_data(page, results)
      next_link = page.link_with(:text => /next 50/)
      page = next_link.click if next_link
    end until next_link.nil?
    # Next we get more detailed information by going to each page of each individual application
    
    results
  end
end

s = CaseyScraper.new
results = s.applications
puts results.to_xml

puts "****"
puts "There were #{results.applications.size} applications"
