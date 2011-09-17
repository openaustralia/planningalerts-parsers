require 'scraper'

class BurnsideScraper < Scraper
  def applications(date)
    url = "http://www.burnside.sa.gov.au/site/page.cfm?u=1276"
    page = agent.get(url)
    page = Nokogiri::HTML(page.body)

    applications = []
    page.xpath('//td[@class="uContentListDesc"]').each do |div|
      on_notice_to = Date.parse(div.at('p').inner_html.split('<br>')[2].split(' - ')[1])

      link = div.xpath('p/a')[0]
      another_url = "http://www.burnside.sa.gov.au/site/" + link["href"]
      subpage = agent.get(another_url)
      subpage = Nokogiri::HTML(subpage.body)

      detail = subpage.xpath("//table[@border=1]/tbody")[0]
      id = detail.xpath('tr')[0].xpath('td/p')[1].text
      address = detail.xpath('tr')[2].xpath('td/p')[1].text.gsub(/\302\240/, ' ')
      description = detail.xpath('tr')[3].xpath('td/p')[1].text.gsub(/\302\240/, ' ')
      email = detail.xpath('tr')[6].xpath('td/p')[1].xpath('a')[0]['href']

      applications << DevelopmentApplication.new(
        :application_id => id,
        :address => address,
        :description => description,
        :info_url => another_url,
        :comment_url => email,
        :on_notice_to => on_notice_to)
    end
    applications
  end
end
