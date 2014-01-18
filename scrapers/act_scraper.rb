require 'scraper'

class ACTScraper < Scraper
  def applications(date)
    url = "http://www.actpla.act.gov.au/topics/your_say/comment/pubnote"
    page = agent.get(url)
    # The way that Mechanize is invoking Nokogiri for parsing the html is for some reason not working with this html which
    # is malformed: See http://validator.w3.org/check?uri=http://apps.actpla.act.gov.au/pubnote/index.asp&charset=(detect+automatically)&doctype=Inline&group=0
    # It's chopping out the content that we're interested in. So, doing the parsing explicitly so we can control how it's done.
    page = Nokogiri::HTML(page.body)
    
    # Walking through the lines. Every 7 lines is a new application
    applications = []
    application = {}
    current_suburb = ''
    page.search('.listing > *').each do |line|
      if line.text.strip! == "Click here to view the plans"
        application[:info_url] = line.children.first["href"]
        applications <<  DevelopmentApplication.new(application)
        application = {}
      else
        if line.text.strip! == ""
          next
        end
        parts = line.text.split(":") 
        if parts.length == 1
          current_suburb = line.text.strip!
        else
          case parts[0]
          when 'Development Application'
            application[:application_id] = parts[1].strip!
          when 'Address'
            application[:address] = "#{parts[1..-1].join(":")}, #{current_suburb}, ACT" unless parts[1].strip! == 'NO ADDRESS'
          when 'Block'
          when 'Proposal'
            application[:description] = parts[1..-1].join(":").strip!
          when 'Period for representations closes'
            application[:on_notice_to] = parts[1].strip
          end
        end

      end
    end
    applications
  end
end
