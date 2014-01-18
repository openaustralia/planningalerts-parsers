# Moved from https://github.com/openaustralia/planningalerts-parsers/blob/master/scrapers/burnside_scraper.rb

require 'mechanize'

def application_detail(info_url)
  agent = Mechanize.new
  page = agent.get(info_url)

  abstract = page.at('p.defaultAbstract')
  unless abstract
    return
  end

  m = abstract.inner_text.match(/Closing Date: (\d+\/\d+\/\d+)/)
  on_notice_to = Date.strptime(m[1], "%d/%m/%Y").to_s

  s = page.at('table').search('td strong')

  record = {
    "council_reference" => s.find{|a| a.inner_text.strip == "Application No:"}.next_sibling.to_s,
    "description" => s.find{|a| a.inner_text.strip == "Nature of Development:"}.next_sibling.to_s,
    "address" => page.at('h2').inner_text + ", SA",
    "info_url" => info_url,
    "comment_url" => info_url,
    "date_scraped" => Date.today.to_s,
    "on_notice_to" => on_notice_to,
  }
  if (ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? rescue true)
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end
end


urls = [
  "http://www.burnside.sa.gov.au/Develop/Planning_Development/Development_Applications_on_Public_Notification/Category_2_Development_Applications",
  "http://www.burnside.sa.gov.au/Develop/Planning_Development/Development_Applications_on_Public_Notification/Category_3_Development_Applications",
  "http://www.burnside.sa.gov.au/Develop/Planning_Development/Development_Applications_on_Public_Notification/Section_49_Public_Consultations"

]

urls.each do |url|

  agent = Mechanize.new
  page = agent.get(url)

  page.search('.content a').each do |a|
    info_url = a["href"]
    application_detail(info_url)
  end

end