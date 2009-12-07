$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'info_master_scraper'
require 'planning_authority_results'

class GoldCoastScraper < InfoMasterScraper
  def planning_authority_name; "Gold Coast City Council, QLD"; end
  def planning_authority_short_name; "Gold Coast"; end

  def applications(date)
    results = PlanningAuthorityResults.new(:name => planning_authority_name, :short_name => planning_authority_short_name)
    table = raw_table(date, "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx?page=search")
    
    # Skip first row of the table
    table.search('tr')[1..-1].each do |row|
      values = row.search('td')
      
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
      email_subject = "Development Application Enquiry: #{da.application_id}"
      da.comment_url = "mailto:gcccmail@goldcoast.qld.gov.au?subject=#{URI.escape(email_subject)}&Body=#{URI.escape(email_body)}"
      results << da
    end
    results
  end
end
