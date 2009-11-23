$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'scraper'
require 'planning_authority_results'

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
      da = DevelopmentApplication.new(
        # This is the "Council ref". We could alternatively use the SPEAR Ref #. Which is correct?
        :application_id => values[2].inner_html.strip,
        # This column sometimes has a link, sometimes doesn't. Handle both cases
        :address => values[0].at('a') ? values[0].at('a').inner_html.strip : values[0].inner_html.strip,
        :date_received => values[10].inner_html.strip)
      # TODO: Need to figure out info_url, comment_url and description
      results << da
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
    results
  end
end

s = CaseyScraper.new
results = s.applications
puts results.to_xml

puts "****"
puts "There were #{results.applications.size} applications"
