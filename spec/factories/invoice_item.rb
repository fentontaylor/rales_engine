FactoryBot.define do
  factory :invoice_item do
    invoice
    item
    quantity { 1 }
    unit_price { item.unit_price }
    created_at { invoice.created_at }
    updated_at { created_at }
  end
end
