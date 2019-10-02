FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity { 1 }
    unit_price { 350 }
  end
end
