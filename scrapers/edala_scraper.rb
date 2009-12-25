require 'cgi_scraper'

class EDALAScraper < CGIScraper
  def initialize(name, short_name, state)
    super(name, short_name, state, "php-cgi -d short_open_tag=0 -d cgi.force_redirect=0 -f", "edala.php")
  end
end
