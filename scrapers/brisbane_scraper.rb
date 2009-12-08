$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'rubygems'

require 'info_master_scraper'

class BrisbaneScraper < InfoMasterScraper
  def initialize(name, short_name)
    super()
    @planning_authority_name, @planning_authority_short_name = name, short_name
  end

  def applications(date)
    table = raw_table_values(date, "http://pdonline.brisbane.qld.gov.au/MasterView/modules/applicationmaster/default.aspx?page=search", 2)
    table.map do |values|
      da = DevelopmentApplication.new(
        # The text in the first column is of the form "<application id> - <description>"
        :application_id => values[1].inner_html.split(" - ")[0],
        :description => values[1].inner_html.split(" - ")[1],
        # TODO: Sometimes the address has what I'm assuming is a lot number in brackets after the address. Handle this properly.
        :address => values[2].inner_html.strip,
        :info_url => agent.page.uri + URI.parse(values[0].at('a').attributes['href']),
        :date_received => values[3].inner_html.strip)
      da.comment_url = "https://obonline.ourbrisbane.com/services/startDASubmission.do?direct=true&daNumber=#{URI.escape(da.application_id)}&sdeprop=#{URI.escape(da.address)}"
      da
    end
  end
end
