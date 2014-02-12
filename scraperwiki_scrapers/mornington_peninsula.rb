require 'mechanize'

url = 'http://www.mornpen.vic.gov.au/Building_Planning/Advertised_Planning_Applications'
agent = Mechanize.new

page = agent.get(url)

page.search('.scrollable-table tbody tr').each do |tr|
  next if tr.search('td')[0].text == 'App No.'

  tds = tr.search('td')

  record = {
    'council_reference' => tds[0].text.strip,
    'description'       => '',
    'address'           => [tds[1].text.strip, tds[2].text.strip, 'VIC'].join(", "),
    'info_url'          => tds[1].search('a').first['href'],
    'comment_url'       => tds[1].search('a').first['href'],
    'date_scraped'      => Date.today.to_s
  }

  info_page = agent.get(record['info_url'])
  record['description'] = info_page.search('.content p.margin-bottom-small').first.text.split(':')[1..-1].join(":").strip

  if ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? 
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
     puts "Skipping already saved record " + record['council_reference']
  end
end