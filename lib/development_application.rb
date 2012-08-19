require 'simple_struct'

class DevelopmentApplication < SimpleStruct
  add_attributes :application_id, :description, :address, :addresses, :on_notice_from, :on_notice_to, :info_url, :comment_url, :date_received
  
  def initialize(options = {})
    @addresses = []
    super
  end
  
  def address
    raise "Can not use address when there are several addresses" if addresses.size > 1
    addresses.first
  end
  
  def address=(a)
    @addresses = [a]
  end

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
    addresses.each do |a|
      xml.application do
        xml.council_reference application_id
        xml.address a
        xml.description description
        xml.info_url info_url
        xml.comment_url comment_url
        xml.date_received date_received
        xml.on_notice_from on_notice_from if on_notice_from
        xml.on_notice_to on_notice_to if on_notice_to
      end
    end
    # Hack to return type of object you would normally expect
    xml.text!("")
  end
  
  private
  
  def parse_date(date)
    if date && !date.kind_of?(Date)
      begin
        Date.parse(date)
      rescue
        nil
      end
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

