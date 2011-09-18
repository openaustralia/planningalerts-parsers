require 'scraper'

class EProclaimScraper < Scraper
  #"https://ipa.charlessturt.sa.gov.au/eproclaim/"
  def initialize(name, short_name, state, url, static_comment_link)
    @url = url
    @static_comment_link = static_comment_link
    super(name, short_name, state)
  end

  def applications(date)
    applications = []
    # First; get cookies
    cookie_url = @url
    request = agent.get(cookie_url)

    # Now it's OK to get the actual notice list
    #print agent.cookies;
    url = @url + "ptgeApplications/ptgePublicNoticeAppsList.asp"

    response = agent.get(url)
    page = Nokogiri::HTML(response.body)

    nodes = page.xpath("//table[@width='95%']/tr/td/table/tr")

    nodes.each do |content|
      td = content.xpath('td')[0]

      unless td['class'] == 't1Error' 

        id = td.css('a').text

        relative_link = "ptgeApplications/" + td.css('a')[0]['href']

        description = td.to_s.split('<br>')[3]
        address = td.to_s.split('<br>')[5]
        closing_date = td.to_s.split('<br>')[7]

        applications << DevelopmentApplication.new(
          :application_id => id,
          :address => address,
          :description => description,
          # For the moment; link to the toplevel eproclaim
          # unless we do horrible workarounds as discussed in
          # https://github.com/openaustralia/planningalerts-parsers/pull/4
          #:info_url => cookie_url + relative_link,
          :info_url => @url,
          :on_notice_to => closing_date,
          :comment_url => @static_comment_link)
      end
    end

    applications
  end
end
