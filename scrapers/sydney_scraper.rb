require 'scraper'

class SydneyScraper < Scraper
  def applications(date)
    url = "http://www.cityofsydney.nsw.gov.au/Development/DAsOnExhibition/DAExhibition.asp"
    page = agent.get(url)
    app = page.at('#main-content > table')
    address = app.search('tr')[0].at('th > strong > a').inner_text.strip
    info_url = extract_relative_url(app.search('tr')[0])
    puts "info_url: #{info_url}"
    puts "address: #{address}"
    line = app.search('tr')[1].at('td').search('p')[0].inner_text
    if line =~ /DA Number: (.+)/
      application_id = $~[1]
    else
      raise "Unexpected form of 'DA Number' line"
    end
    puts "application_id: #{application_id}"
    description_para = app.search('tr')[1].at('td').search('p')[1]
    # Remove unnecessary link which contains text that isn't part of the description
    description_para.at('a').remove
    description = description_para.inner_text
    puts "description: #{description}"
    on_notice_to_para = app.search('tr')[1].at('td').search('p')[2]
    on_notice_to_para.at('strong').remove
    on_notice_to = on_notice_to_para.inner_text
    puts "on_notice_to: #{on_notice_to}"
    exit
    []
  end
end