require 'rubygems'
require 'builder'
require 'simple_struct'
require 'uri'
require 'date_with_non_american_bias'

class DevelopmentApplication < SimpleStruct :application_id, :description, :address, :on_notice_from, :on_notice_to, :info_url, :comment_url, :date_received
  def info_url=(url)
    @info_url = parse_url(url)
  end
  
  def comment_url=(url)
    @comment_url = parse_url(url)
  end
  
  def on_notice_from=(date)
    @on_notice_from = parse_date(date)
  end
  
  def on_notice_to=(date)
    @on_notice_to = parse_date(date)
  end
  
  def date_received=(date)
    @date_received = parse_date(date)
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
      xml.date_received date_received
    end
  end
  
  private
  
  def parse_date(date)
    if date && !date.kind_of?(Date)
      Date.parse(date)
    else
      date
    end
  end
  
  def parse_url(url)
    if url && !url.kind_of?(URI)
      URI.parse(url)
    else
      url
    end
  end
end

