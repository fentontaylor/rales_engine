FactoryBot.define do
  factory :customer do
    first_name { "Bob" }
    last_name { ('A'..'Z').to_a.sample + '.' }
  end
end
