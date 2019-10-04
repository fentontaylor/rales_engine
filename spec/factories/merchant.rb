FactoryBot.define do
  factory :merchant do
    sequence(:name) { |x| "Bob Ross Paints #{x}" }
    created_at { Time.now }
    updated_at { created_at }
  end
end
