FactoryBot.define do
  factory :item do
    sequence(:name) { |x| "Thingamabob #{x}"}
    description { "It's a thing" }
    unit_price { rand(100..10000) }
    created_at { Time.now }
    updated_at { created_at }
    merchant
  end
end
