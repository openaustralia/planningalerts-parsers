require 'scraper'

class EProclaimScraper < Scraper
  #"https://ipa.charlessturt.sa.gov.au/eproclaim/"
  def initialize(name, short_name, state, url)
    @@url = url
    super(name, short_name, state)
  end

  def applications(date)
    applications = []
    # First; get cookies
    cookie_url = @@url
    request = agent.get(cookie_url)

    # Now it's OK to get the actual notice list
    #print agent.cookies;
    url = @@url + "ptgeApplications/ptgePublicNoticeAppsList.asp"

    response = agent.get(url)
    page = Nokogiri::HTML(response.body)

    nodes = page.xpath("//table[@width='95%']/tr/td/table/tr")

    begin
        nodes.each do |content|

          td = content.xpath('td')[0]
          id = td.css('a').text

          relative_link = td.css('a')[0]['href']

          description = td.to_s.split('<br>')[3]
          address = td.to_s.split('<br>')[5]
          closing_date = td.to_s.split('<br>')[7]

          applications << DevelopmentApplication.new(
            :application_id => id,
            :address => address,
            :description => description,
            :info_url => cookie_url + relative_link)
        end
    rescue
    end

    applications
  end
end
