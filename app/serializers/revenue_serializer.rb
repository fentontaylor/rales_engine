class RevenueSerializer
  attr_reader :hash

  def initialize(hash)
    @hash = hash
  end

  def set_dollar_price_as_string
    digits = @hash['total_revenue'].to_s.split('')
    cents = digits.pop(2)
    @hash['total_revenue'] = digits.join + '.' + cents.join
    @hash
  end

  def json
    {
      data: {
        attributes: set_dollar_price_as_string
      }
    }
  end
end
