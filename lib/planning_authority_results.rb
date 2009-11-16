require 'development_application'

class PlanningAuthorityResults
  attr_reader :applications, :name, :short_name
  
  def initialize(options = {})
    @name = options.delete(:name)
    @short_name = options.delete(:short_name)
    raise "Unexpected keys #{options.keys.join(', ')} used" unless options.empty?
    @applications = []
  end
  
  def <<(da)
    @applications << da
  end
  
  def to_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]
    xml.planning do
      xml.authority_name name
      xml.authority_short_name short_name
      xml.applications do
        applications.each do |application|
          xml << application.to_xml(:builder => Builder::XmlMarkup.new(:indent => options[:indent], :margin => 2))
        end
      end
    end
  end
end