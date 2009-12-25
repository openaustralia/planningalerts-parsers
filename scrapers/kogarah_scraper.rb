require 'cgi_scraper'

class KogarahScraper < CGIScraper
  def initialize(name, short_name, state)
    super(name, short_name, state, "perl", "kogarah.pl")
  end
end
