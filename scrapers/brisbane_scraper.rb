$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'rubygems'

require 'info_master_scraper'

class BrisbaneScraper < InfoMasterScraper
  def planning_authority_name; "Brisbane City Council, QLD"; end
  def planning_authority_short_name; "Brisbane"; end

  def applications(date)
    table = raw_table(date, "http://pdonline.brisbane.qld.gov.au/MasterView/modules/applicationmaster/default.aspx?page=search")
    applications = []
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
      applications << da
    end
    applications
  end
end
