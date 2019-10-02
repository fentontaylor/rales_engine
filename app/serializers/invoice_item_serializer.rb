class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :invoice_id, :item_id, :quantity

  attribute :unit_price do |obj|
    obj.dollar_price_as_string
  end
end
