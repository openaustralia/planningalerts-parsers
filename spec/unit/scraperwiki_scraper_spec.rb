require 'spec_helper'

describe ScraperWikiScraper do
  it 'should switch the ScraperWiki database' do
    sw = ScraperWikiScraper.new('name', 'short_name', 'state')
    sw.stub(:scrape)

    sw.applications(Date.today)

    ScraperWiki.instance_variable_get(:@config).should == {db: '/tmp/short_name.sqlite'}
  end
end
