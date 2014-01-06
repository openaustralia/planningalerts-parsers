require 'mechanize'

url = "http://rccweb.rockdale.nsw.gov.au/EPlanning/Pages/XC.Track/SearchApplication.aspx?d=last14days&k=LodgementDate&t=217"

agent = Mechanize.new
page = agent.get(url)


page.search('.result').each do |application|
  # Skip multiple addresses
  next unless application.search("strong").select{|x|x.inner_text != "Approved"}.length == 1

  address = application.search("strong").first


  more_data = application.children[10].inner_text.split("\r\n")
  more_data[2].strip!
  
  application_id = application.search('a').first['href'].split('?').last
  info_url = "http://rccweb.rockdale.nsw.gov.au/EPlanning/Pages/XC.Track/SearchApplication.aspx?id=#{application_id}"
  record = {
    "council_reference" => application.search('a').first.inner_text,
    "description" => application.children[4].inner_text,
    "date_received" => Date.parse(more_data[2][0..9], 'd/m/Y').to_s,
    # TODO: There can be multiple addresses per application
    "address" => application.search("strong").first.inner_text,
    "date_scraped" => Date.today.to_s,
    "info_url" => info_url,
    # Can't find a specific url for commenting on applications.
    "comment_url" => info_url,
  }
  # DA03NY1 appears to be the event code for putting this application on exhibition
  e = application.search("Event EventCode").find{|e| e.inner_text.strip == "DA03NY1"}
  if e
    record["on_notice_from"] = Date.parse(e.parent.at("LodgementDate").inner_text).to_s
    record["on_notice_to"] = Date.parse(e.parent.at("DateDue").inner_text).to_s
  end
  
  if (ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? rescue true)
    ScraperWiki.save_sqlite(['council_reference'], record)
  else
    puts "Skipping already saved record " + record['council_reference']
  end
end
