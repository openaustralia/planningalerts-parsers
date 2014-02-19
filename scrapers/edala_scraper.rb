require 'nokogiri'
require 'net/http'
require 'htmlentities'

require 'scraper'

class EdalaScraper < Scraper
  def fetch_index(from)
    url = URI.parse("https://www.edala.sa.gov.au/edala/EDALAView.aspx?PageMode=ApplicationSearchResultsView&hdnCoAId=&SearchType=View&ReferenceNumber=&DevelopmentNumber=&ApplicationStatusId=&CoAStageStatusId=&UseAdvancedSearch=1&dLodgedFrom=#{from}&dLodgedTo=#{from}&ApplicantFirstName=&ApplicantLastName=&ApplicantOrganisation=&OwnerFirstName=&OwnerLastName=&OwnerOrganisation=&CouncilId=&TitleReferenceTypeId=&Volume=&Folio=&PlanTypeId=&PlanNumber=&ParcelNumber=&Hundred=&ReferenceSection=&HouseNumber=&LotNumber=&AddressStreet=&AddressSuburb=&CoAStageNumber=&DPNumber=&SortBy=LodgementDate")

    Net::HTTP.get_response(url).body
  end

  def individual_uri(id)
    "https://www.edala.sa.gov.au/edala/EDALAView.aspx?PageMode=ApplicationDisplayView&ApplicationId=#{id}"  
  end

  def fetch_individual(id)
    url = URI.parse(individual_uri(id))

    Net::HTTP.get_response(url).body
  end

  def build_application(tr)
    id =  tr.css("td a").first.text.strip
    link = individual_uri(id)

    date = tr.xpath("td[2]").first.text.strip

    another_document = Nokogiri::HTML(fetch_individual(id))
    

    summary = another_document.xpath("/html/body/table/tbody/tr[2]/td/table[3]/tbody/tr[3]/td[2]")
    description = summary[0].text.strip

    tbody = another_document.xpath('//table[@id="propterydetail1_0"]/tbody').first

    house_number = tbody.xpath('tr[1]/td[2]').first.text.strip
    lot_number   = tbody.xpath('tr[2]/td[2]').first.text.strip
    street       = tbody.xpath('tr[3]/td[2]').first.text.strip
    suburb       = tbody.xpath('tr[4]/td[2]').first.text.strip


    parts = []
    parts << lot_number if lot_number && lot_number != ''
    parts << house_number if house_number && house_number != ''


    address = [
      "#{parts.join("/")} #{street}".strip,
      suburb,
      "SA"
    ].select{|x| x!= ''}.join(", ")

    DevelopmentApplication.new(
      :address => address,
      :description => description,
      :application_id => id,
      :info_url => link,
      :on_notice_from => date
    )
  end

  def applications(date)
    data = fetch_index(date.strftime('%Y+%m+%d'))

    document = Nokogiri::HTML(data)

    rows= document.css("#General_0 tr.content")

    rows.collect{|tr| build_application(tr)}  
  end
end
