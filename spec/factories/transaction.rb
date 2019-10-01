FactoryBot.define do
  factory :transaction do
    invoice
    credit_card_number { ('444456567890' + rand(1000..9999).to_s).to_i }
    result { ['failed', 'success'].sample }
  end
end
