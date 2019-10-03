FactoryBot.define do
  factory :invoice do
    customer
    merchant
    status { "shipped" }
    created_at { Time.now }
    updated_at { created_at }
  end
end
