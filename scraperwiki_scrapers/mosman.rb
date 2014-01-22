require 'date'
require 'mechanize'

agent = Mechanize.new
url = "http://portal.mosman.nsw.gov.au/pages/xc.track/SearchApplication.aspx?d=thismonth&t=8,5&k=LodgementDate"

page = agent.get(url)
page.search('.result').each do |app|
  app.search('span').remove if app.search('span').length > 0

  record = { }

  record[:info_url] = "http://portal.mosman.nsw.gov.au/pages/xc.track/" + app.children[1]['href']
  record[:comment_url] = "http://portal.mosman.nsw.gov.au/pages/xc.track/" + app.children[1]['href']
  record[:description] = app.children[4].to_s
  record[:date_received] = app.children[6].to_s.split(":")[1].strip
  record[:address] = app.children[8].to_s.split(":")[1].strip + ", Mosman, NSW"
  record[:council_reference] = app.children[1].text.to_s

  if ScraperWiki.select("* from swdata where `council_reference`='#{record[:council_reference]}'").empty? 
    ScraperWiki.save_sqlite([:council_reference], record)
  else
     puts "Skipping already saved record " + record[:council_reference]
  end

end