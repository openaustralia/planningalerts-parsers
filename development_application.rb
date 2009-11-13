class DevelopmentApplication
  attr_reader :application_id, :description, :address, :from, :to

  def initialize(params = {})
    @from = params.delete(:from)
    @to = params.delete(:to)
    @application_id = params.delete(:application_id)
    @description = params.delete(:description)
    @address = params.delete(:address)
    raise "Unexpected keys #{params.keys.join(', ')} used" unless params.empty?

    # Parse date fields
    @from = Date.parse(@from) if @from
    @to = Date.parse(@to) if @to
  end
end

