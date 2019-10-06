module MyModules
  module PriceConverter
    def method_name
      def dollar_price_as_string
        digits = self.unit_price.to_s.split('')
        cents = digits.pop(2)
        digits.join + '.' + cents.join
      end
    end
  end
end
