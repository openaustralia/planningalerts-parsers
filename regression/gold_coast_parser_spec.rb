$:.unshift "#{File.dirname(__FILE__)}/../lib"
$:.unshift "#{File.dirname(__FILE__)}/.."

require 'spec'
require 'parse_gold_coast'

describe GoldCoastParser do
  it "should return a particular expected planning application for a particular day" do
    date = Date.new(2009, 11, 12)
    GoldCoastParser.new.applications(date).applications.should include(DevelopmentApplication.new(
      :application_id => "MCU2900747",
      :description => "Description: APARTMENT BUILDING\r\n      Class: IMPACT\r\n      Work Type:",
      :date_received => date,
      :address => "21 ELIZABETH AVENUE, BROADBEACH 4218",
      :info_url => "http://pdonline.goldcoast.qld.gov.au/masterview/modules/applicationmaster/default.aspx?page=wrapper&key=155306",
      :comment_url => "mailto:gcccmail@goldcoast.qld.gov.au?subject=Development%20Application%20Enquiry:%20MCU2900747&Body=Thank%20you%20for%20your%20enquiry.%0A%0APlease%20complete%20the%20following%20details%20and%20someone%20will%20get%20back%20to%20you%20as%20soon%20as%20possible.%20%20Before%20submitting%20you%20email%20request%20you%20may%20want%20to%20check%20out%20the%20Frequently%20Asked%20Questions%20(FAQ's)%20Located%20at%20http://pdonline.goldcoast.qld.gov.au/masterview/documents/FREQUENTLY_ASKED_QUESTIONS_PD_ONLINE.pdf%0A%0AName:%20%0A%0AContact%20Email%20Address:%20%0A%0ABusiness%20Hours%20Contact%20Phone%20Number:%20%0A%0AYour%20query%20regarding%20this%20Application:%20%0A%0A"
    ))
  end
end

