require 'scraper'

class MarrickvilleScraper < Scraper
  def applications(date)
    info_url = "http://www.marrickville.nsw.gov.au/p190800/eproclaim/index.asp?request_url=ptgeApplications/ptgePublicNoticeAppsList.asp"
    comment_url = "http://www.marrickville.nsw.gov.au/planninganddevelopment/da/lodgecomment.htm"
    
    # First get this page to initialise the session cookie
    agent.get(info_url)
    url = "http://www.marrickville.nsw.gov.au/p190800/eproclaim/ptgeApplications/ptgePublicNoticeAppsList.asp"
    page = agent.get(url)
    
    page.search('td.t1PageContentMainCell').map do |app|
      # TODO: Add the on_notice_to date
      DevelopmentApplication.new(
        :application_id => app.search('a').inner_text,
        :description => app.inner_html.split('<br>')[3],
        :address => app.inner_html.split('<br>')[5],
        :info_url => info_url,
        :comment_url => comment_url)
    end
  end
end
