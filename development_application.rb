require 'rubygems'
require 'builder'

class DevelopmentApplication
  attr_reader :application_id, :description, :address, :on_notice_from, :on_notice_to, :info_url, :comment_url

  def initialize(params = {})
    @on_notice_from = params.delete(:on_notice_from)
    @on_notice_to = params.delete(:on_notice_to)
    @application_id = params.delete(:application_id)
    @description = params.delete(:description)
    @address = params.delete(:address)
    @info_url = params.delete(:info_url)
    @comment_url = params.delete(:comment_url)
    raise "Unexpected keys #{params.keys.join(', ')} used" unless params.empty?

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

