planningalerts-parsers [![Build Status](https://secure.travis-ci.org/openaustralia/planningalerts-parsers.png?branch=master)](http://travis-ci.org/openaustralia/planningalerts-parsers) [![Dependency Status](https://gemnasium.com/openaustralia/planningalerts-parsers.png)](https://gemnasium.com/openaustralia/planningalerts-parsers)
======================

Scrapers for [PlanningAlerts](http://www.planningalerts.org.au/).

Contributing
------------

If you'd like to [contribute a scraper](http://www.planningalerts.org.au/getinvolved) it's not essential to understand this repository. For example it might be easier to create a scraper on [ScraperWiki](http://scraperwiki.com/).

Get in touch on our [development mailing list](http://groups.google.com/group/openaustralia-dev) and hassle us to make these instructions better :)

Installation
------------

    bundle # Install required Gems
    rake   # Run tests

To test your scraper during development use the `output` Rake task, e.g. `rake output[ballina]`

License
-------

GPLv2, see the LICENSE file for full details.
