require 'rubygems'
require 'builder'
require 'simple_struct'

class DevelopmentApplication < SimpleStruct :application_id, :description, :address, :on_notice_from, :on_notice_to, :info_url, :comment_url
  def initialize(options = {})
    super options
    # Parse date fields
    @on_notice_from = Date.parse(@on_notice_from) if @on_notice_from
    @on_notice_to = Date.parse(@on_notice_to) if @on_notice_to
  end
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.application do
      xml.council_reference application_id
      xml.address address
      xml.description description
      xml.info_url info_url
      xml.comment_url comment_url
    end
  end
end

