require 'spec_helper'

describe ScraperWikiScraper do
  describe '#applications' do
    before :each do
      # Stops databases being created during tests
      ScraperWiki.stub(:select).and_return([])

      # Some jiggery pokery to get a path code in lib sees
      root_path = File.join(File.dirname(__FILE__), '..', '..')
      @root_path_relative_to_lib = File.join(File.absolute_path(root_path), 'lib', '..')

      sw = ScraperWikiScraper.new('name', 'short_name', 'state')
      sw.stub(:scrape)

      sw.applications(Date.today)
    end

    it 'should switch the ScraperWiki database' do
      ScraperWiki.instance_variable_get(:@config).should == {db: @root_path_relative_to_lib + '/scraperwiki_databases/short_name.sqlite'}
    end

    it 'should change the ScraperWiki database when we select a different scraper' do
      sw2 = ScraperWikiScraper.new('name2', 'short_name2', 'state2')
      sw2.stub(:scrape)
      sw2.applications(Date.today)
      ScraperWiki.instance_variable_get(:@config).should == {db: @root_path_relative_to_lib + '/scraperwiki_databases/short_name2.sqlite'}
    end
  end
end
