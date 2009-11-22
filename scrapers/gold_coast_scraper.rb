$:.unshift "#{File.dirname(__FILE__)}/../lib"
require 'scraper'
require 'planning_authority_results'

class GoldCoastScraper < Scraper
  @planning_authority_name = "Gold Coast City Council"
  @planning_authority_short_name = "Gold Coast"

  # TODO: Extract this into Scraper
  class << self
    attr_reader :planning_authority_name, :planning_authority_short_name
  end
  
  def applications(date)
    url = "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx?page=search"
    page = agent.get(url)
    results = PlanningAuthorityResults.new(:name => self.class.planning_authority_name, :short_name => self.class.planning_authority_short_name)
    
    # Click the Ok button on the form
    form = page.forms.first
    form.submit(form.button_with(:name => "_ctl2:btnOk"))

    # Get the page again
    page = agent.get(url)

    search_form = page.forms.first
    search_form.set_fields(
      "_ctl3:drDates:txtDay1" => date.day,
      "_ctl3:drDates:txtMonth1" => date.month,
      "_ctl3:drDates:txtYear1" => date.year,
      "_ctl3:drDates:txtDay2" => date.day,
      "_ctl3:drDates:txtMonth2" => date.month,
      "_ctl3:drDates:txtYear2" => date.year)
    table = search_form.submit(search_form.button_with(:name => "_ctl3:btnSearch")).search('span#_ctl3_lblData > table')
    
    # TODO: Need to handle what happens when the results span multiple pages. Can this happen?

    # Skip first row of the table
    table.search('tr')[1..-1].each do |row|
      values = row.search('td')
      
      da = DevelopmentApplication.new(
        :application_id => values[1].inner_html.strip,
        :description => values[3].inner_text.split("\n")[3..-1].join("\n").strip,
        :address => values[3].inner_text.split("\n")[1].strip,
        :info_url => page.uri + URI.parse(values[0].at('a').attributes['href']),
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
