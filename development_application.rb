class DevelopmentApplication
  attr_reader :application_id, :description, :address, :on_notice_from, :on_notice_to

  def initialize(params = {})
    @on_notice_from = params.delete(:on_notice_from)
    @on_notice_to = params.delete(:on_notice_to)
    @application_id = params.delete(:application_id)
    @description = params.delete(:description)
    @address = params.delete(:address)
    raise "Unexpected keys #{params.keys.join(', ')} used" unless params.empty?

    # Parse date fields
    @on_notice_from = Date.parse(@on_notice_from) if @on_notice_from
    @on_notice_to = Date.parse(@on_notice_to) if @on_notice_to
  end
end

