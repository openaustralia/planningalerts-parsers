class DevelopmentApplication
  attr_reader :from, :to

  def initialize(params = {})
    @from = params.delete(:from)
    @from = Date.parse(@from) if @from
    @to = params.delete(:to)
    @to = Date.parse(@to) if @to
    raise "Unexpected keys #{params.keys.join(', ')} used" unless params.empty?
  end
end

