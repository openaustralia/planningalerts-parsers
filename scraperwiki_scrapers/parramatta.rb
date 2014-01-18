require 'rss/2.0'
require 'date'
require 'mechanize'

url = "http://eplanning.parracity.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx?o=rss&d=last14days"

agent = Mechanize.new

page = agent.get(url)
form = page.forms.first
form.checkbox_with(:name => /Agree/).check
page = form.submit(form.button_with(:name => /Agree/))

t = page.content.to_s
# I've no idea why the RSS feed says it's encoded as utf-16 when as far as I can tell it isn't
# Hack it by switching it back to utf-8
t.gsub!("utf-16", "utf-8")

feed = RSS::Parser.parse(t, false)

feed.channel.items.each do |item|
  # Seeing a record without an address (which is obviously useless). So, skipping
  t = item.description.split(/\. /)
  if t.count >= 2
    record = {
      'council_reference' => item.title.split(' ')[0],
      'description'       => t[1].strip,
      # Have to make this a string to get the date library to parse it
      'date_received'     => Date.parse(item.pubDate.to_s),
      'address'           => t[0].strip,
      'info_url'          => "http://eplanning.parracity.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx#{item.link}",
      # Comment URL is actually an email address but I think it's best
      # they go to the detail page
      'comment_url'       => "http://eplanning.parracity.nsw.gov.au/Pages/XC.Track/SearchApplication.aspx#{item.link}",
      'date_scraped'      => Date.today.to_s
    }
    if (ScraperWiki.select("* from swdata where `council_reference`='#{record['council_reference']}'").empty? rescue true)
      ScraperWiki.save_sqlite(['council_reference'], record)
    else
       puts "Skipping already saved record " + record['council_reference']
    end
  end
end

