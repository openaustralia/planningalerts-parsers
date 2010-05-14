require 'scraper'
require 'csv'

class StonningtonScraper < Scraper
  def applications(date)
    url = "http://www.stonnington.vic.gov.au/www/html/856-planning-register-online.asp"
    comment_url = "http://www.stonnington.vic.gov.au/www/html/678-objecting-to-a-planning-application-.asp"
    page = agent.get(url)
    form = page.forms.first
    form.checkbox_with(:name => "agree").check
    page = form.click_button
    form = page.forms.first
    form["date_from"] = form["date_to"] = date.day
    form["date_from_month"] = form["date_to_month"] = Date::ABBR_MONTHNAMES[date.month]
    form["date_from_year"] = form["date_to_year"] = date.year
    page = form.click_button(form.button_with(:name => "Search"))
    # If there are returned results we expect there to be two forms
    if page.forms.size == 1
      []
    else
      form = page.forms.first
      # Click to download tab delimited data
      page = form.click_button
      data = CSV.parse(page.body, "\t")
      data[1..-1].map do |row|
        DevelopmentApplication.new(
          :application_id => row[1],
          :description => row[9],
          :address => row[3] + ", VIC",
          :date_received => row[2],
          :on_notice_to => row[11],
          :info_url => "#{url}?id=#{row[1]}",
          :comment_url => comment_url)
      end
    end
  end
end