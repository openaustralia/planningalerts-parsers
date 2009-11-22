require 'rubygems'
require 'builder'
require 'simple_struct'
require 'uri'

class DevelopmentApplication < SimpleStruct :application_id, :description, :address, :on_notice_from, :on_notice_to, :info_url, :comment_url
  def initialize(options = {})
    super options

    # TODO: Make this less ugly
    # Parse attributes
    self.on_notice_from = @on_notice_from
    self.on_notice_to = @on_notice_to
    self.info_url = @info_url
    self.comment_url = @comment_url
  end
  
  def info_url=(url)
    @info_url = parse_url(url)
  end
  
  def comment_url=(url)
    @comment_url = parse_url(url)
  end
  
  def parse_date(date)
    Date.parse(date) if date
  end
  
  def on_notice_from=(date)
    @on_notice_from = parse_date(date)
  end
  
  def on_notice_to=(date)
    @on_notice_to = parse_date(date)
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
  
  private
  
  def parse_url(url)
    URI.parse(url) if url
  end
end

