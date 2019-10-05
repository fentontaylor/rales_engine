class BestDaySerializer
  def initialize(data)
    @data = data
  end

  def json
    {
      data: {
        attributes: @data
      }
    }

  end
end
