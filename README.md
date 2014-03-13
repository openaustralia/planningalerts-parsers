# We're [phasing out](https://github.com/openaustralia/planningalerts-parsers/issues/56) scrapers here in favour of using our new scraper platform [Morph](https://morph.io).

planningalerts-parsers [![Build Status](https://secure.travis-ci.org/openaustralia/planningalerts-parsers.png?branch=master)](http://travis-ci.org/openaustralia/planningalerts-parsers) [![Dependency Status](https://gemnasium.com/openaustralia/planningalerts-parsers.png)](https://gemnasium.com/openaustralia/planningalerts-parsers)
======================

Scrapers for [PlanningAlerts](http://www.planningalerts.org.au/).

Installation
------------

    bundle # Install required Gems
    rake   # Run tests

To test your scraper during development use the `output` Rake task, e.g. `rake output[ballina]`

Contributing
------------

**Issue tracking**: Scraper issues imported from Jira may also be found on the [planningalerts-app](https://github.com/openaustralia/planningalerts-app/issues?labels=Scraper) repository.

If you'd like to [contribute a scraper](http://www.planningalerts.org.au/getinvolved) it's not essential to understand this repository. For example it might be easier to create a scraper on [ScraperWiki](http://scraperwiki.com/).

Get in touch on our [development mailing list](http://groups.google.com/group/openaustralia-dev) and hassle us to make these instructions better :)

## Covering more councils

In addition to this page, **see our [How to write a scraper guide](http://www.planningalerts.org.au/how_to_write_a_scraper)**.

To find councils to write scrapers for check [what we already cover and what's potentially broken](http://www.planningalerts.org.au/authorities/). We also have a list of [all Australian councils](https://spreadsheets.google.com/ccc?key=0AmvYMal8CGUsdG1tM0lEWUctR194eGN6bUh0VGFfc1E&hl=en) you can check and a list of the [most wanted PlanningAlerts scrapers](http://www.planningalerts.org.au/alerts/statistics).

### Common planning systems
The following systems are used by a number of councils around Australia. This means it can be easy to scrape them, just copy someone else's ScraperWiki scraper and make a few minor changes.

* **Infomaster** is a very common system, if you find a council using it just fork the [Randwick scraper on ScraperWiki](https://scraperwiki.com/scrapers/randwick_city_council_development_applications/). It's likely you'll only need small customisations. [Scraper wiki tag](https://scraperwiki.com/tags/infomaster)
* **ICON Software's PlanningXChange/XC Track** system always(?) has an RSS feed, even if they don't advertise it. Check the [Parramatta scraper](https://scraperwiki.com/scrapers/parramatta-city-council-development-applications/) for an example. I think you just put `o=rss` in the query string and it outputs RSS. [Scraper wiki tag](https://scraperwiki.com/tags/PlanningXChange)
* **ePathway** is another common system. There's a [ScraperWiki example](https://scraperwiki.com/scrapers/knox_regional_council_development_applications/) and a [custom scraper](https://github.com/openaustralia/planningalerts-parsers/blob/master/scrapers/wollongong_scraper.rb) too. [Scraper wiki tag](https://scraperwiki.com/tags/epathway)

License
-------

GPLv2, see the LICENSE file for full details.
