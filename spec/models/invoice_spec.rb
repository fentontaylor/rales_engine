require 'rails_helper'

describe Invoice do
  describe 'validations' do
    it { should validate_presence_of :status }
    it { should validate_presence_of :merchant_id }
    it { should validate_presence_of :customer_id }
  end
end
