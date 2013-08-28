require 'spec_helper'

describe 'Scraping pages to XML' do
  it 'should return known good XML for all currently working Ruby scrapers' do
    existing_ruby_scrapers = %w(boroondara_city brisbane logan warringah wollongong wyong)

    existing_ruby_scrapers.each do |short_name|
      VCR.use_cassette(short_name) do
        expected_results = File.read("#{File.dirname(__FILE__)}/../fixtures/#{short_name}.xml")
        Scrapers::scraper_factory(short_name).results_as_xml(Date.new(2013, 8, 27)).should == expected_results
      end
    end
  end
end
