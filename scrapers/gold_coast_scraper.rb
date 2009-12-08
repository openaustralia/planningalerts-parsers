$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'info_master_scraper'

class GoldCoastScraper < InfoMasterScraper
  attr_reader :agent, :planning_authority_name, :planning_authority_short_name

  def initialize(name, short_name)
    super()
    @planning_authority_name, @planning_authority_short_name = name, short_name
  end

  def applications(date)
    url = "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx?page=search"
    raw_table_values(date, url, 1).map do |values|
      da = DevelopmentApplication.new(
        :application_id => values[1].inner_html.strip,
        :description => values[3].inner_text.split("\n")[3..-1].join("\n").strip,
        :address => values[3].inner_text.split("\n")[1].strip,
        :info_url => agent.page.uri + URI.parse(values[0].at('a').attributes['href']),
        :date_received => values[2].inner_html)
      email_body = <<-EOF
Thank you for your enquiry.

Please complete the following details and someone will get back to you as soon as possible.  Before submitting you email request you may want to check out the Frequently Asked Questions (FAQ's) Located at http://pdonline.goldcoast.qld.gov.au/masterview/documents/FREQUENTLY_ASKED_QUESTIONS_PD_ONLINE.pdf

Name: 

Contact Email Address: 

Business Hours Contact Phone Number: 

Your query regarding this Application: 

      EOF
      da.comment_url = email_url("gcccmail@goldcoast.qld.gov.au", "Development Application Enquiry: #{da.application_id}", email_body)
      da
    end
  end
end
