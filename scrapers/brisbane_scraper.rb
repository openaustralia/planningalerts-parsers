$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'rubygems'

require 'planning_authority_results'
require 'info_master_scraper'

class BrisbaneScraper < InfoMasterScraper
  @planning_authority_name = "Brisbane City Council"
  @planning_authority_short_name = "Brisbane"

  def applications(date)
    results = PlanningAuthorityResults.new(:name => self.class.planning_authority_name, :short_name => self.class.planning_authority_short_name)
    table = raw_table(date, "http://pdonline.brisbane.qld.gov.au/MasterView/modules/applicationmaster/default.aspx?page=search")

    # Skip first two rows of the table
    table.search('tr')[2..-1].each do |row|
      values = row.search('td')
  
      da = DevelopmentApplication.new(
        # The text in the first column is of the form "<application id> - <description>"
        :application_id => values[1].inner_html.split(" - ")[0],
        :description => values[1].inner_html.split(" - ")[1],
        # TODO: Sometimes the address has what I'm assuming is a lot number in brackets after the address. Handle this properly.
        :address => values[2].inner_html.strip,
        :info_url => agent.page.uri + URI.parse(values[0].at('a').attributes['href']),
        :date_received => values[3].inner_html.strip)
      da.comment_url = "https://obonline.ourbrisbane.com/services/startDASubmission.do?direct=true&daNumber=#{URI.escape(da.application_id)}&sdeprop=#{URI.escape(da.address)}"
      results << da
    end
    results
  end
end
