FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity { (1..5).to_a.sample }
    unit_price { 350 }
  end
end
