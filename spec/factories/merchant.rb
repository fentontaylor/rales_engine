FactoryBot.define do
  factory :merchant do
    sequence(:name) { |x| "Bob Ross Paints #{x}" }
  end
end
