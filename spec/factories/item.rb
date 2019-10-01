FactoryBot.define do
  factory :item do
    sequence(:name) { |x| "Thingamabob #{x}"}
    description { "It's a thing" }
    merchant
  end
end
