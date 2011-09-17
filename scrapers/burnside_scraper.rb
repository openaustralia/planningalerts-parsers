require 'scraper'

class BurnsideScraper < Scraper
  def applications(date)
    url = "http://www.burnside.sa.gov.au/site/page.cfm?u=1276"
    page = agent.get(url)
    page = Nokogiri::HTML(page.body)


    applications = []
    page.xpath('//td[@class="uContentListDesc"]').each do |div|
      link = div.xpath('p/a')[0]

      another_url = "http://www.burnside.sa.gov.au/site/" + link["href"]
      subpage = agent.get(another_url)


      subpage = Nokogiri::HTML(subpage.body)

      detail = subpage.xpath("//table[@border=1]/tbody")[0]
      id = detail.xpath('tr')[0].xpath('td/p')[1].text

      address = detail.xpath('tr')[2].xpath('td/p')[1].text.gsub(/\302\240/, ' ')

      description = detail.xpath('tr')[3].xpath('td/p')[1].text
      email = detail.xpath('tr')[6].xpath('td/p')[1].xpath('a')[0]['href']


      applications << DevelopmentApplication.new(
        :application_id => id,
        :address => address,
        :description => description,
        :info_url => another_url,
        :comment_url => email)
    end

    applications
  end
 
end
