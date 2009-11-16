require 'rubygems'
require 'builder'

class DevelopmentApplication
  attr_reader :application_id, :description, :address, :on_notice_from, :on_notice_to, :info_url, :comment_url

  def initialize(options = {})
    @on_notice_from = options.delete(:on_notice_from)
    @on_notice_to = options.delete(:on_notice_to)
    @application_id = options.delete(:application_id)
    @description = options.delete(:description)
    @address = options.delete(:address)
    @info_url = options.delete(:info_url)
    @comment_url = options.delete(:comment_url)
    raise "Unexpected keys #{options.keys.join(', ')} used" unless options.empty?

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

