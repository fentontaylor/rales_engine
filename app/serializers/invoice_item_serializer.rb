class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :invoice_id, :item_id, :quantity, :unit_price
end
