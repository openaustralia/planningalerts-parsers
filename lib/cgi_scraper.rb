# A simple Ruby wrapper around any scraper script that renders the correct XML and obeys the CGI interface
# Can use this to give php and perl, for example, the same web interface as all the other Ruby scrapers
# Performance is not really an issue so this very roundabout way of doing things is sort of okay.

class CGIScraper < ScraperBase
  def initialize(name, short_name, state, command, script)
    super(name, short_name, state)
    @command, @script = command, script
  end

  def results_as_xml(date)
    ENV['REQUEST_METHOD'] = 'GET'
    ENV['QUERY_STRING'] = "year=#{date.year}&month=#{date.month}&day=#{date.day}"
    ENV['PATH_INFO'] = "?" + ENV['QUERY_STRING']
    ENV['PATH_TRANSLATED'] = ENV['PATH_INFO']
    ENV['SCRIPT_FILENAME'] = File.expand_path("#{File.dirname(__FILE__)}/../cgi-scrapers/#{@script}")
    f = IO.popen("#{@command} #{ENV['SCRIPT_FILENAME']}")
    ret = f.read
    # Remove any headers that are set. Crude way to do this is remove anything before the proper XML starts (with a "<")
    ret[ret.index("<")..-1]
  end
end
