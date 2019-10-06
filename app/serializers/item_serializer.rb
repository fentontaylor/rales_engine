class ItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :name, :description, :merchant_id

  attribute :unit_price do |obj|
    digits = obj.unit_price.to_s.split('')
    cents = digits.pop(2)
    digits.join + '.' + cents.join  end
end
