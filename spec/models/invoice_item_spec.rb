require 'rails_helper'

describe InvoiceItem do
  describe 'validations' do
    it { should validate_presence_of :invoice_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :quantity }
    it { should validate_presence_of :unit_price }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :invoice }
  end

  describe 'instance methods' do
    it '#dollar_price_as_string' do
      invoice_item = create(:invoice_item, unit_price: 12345)

      expect(invoice_item.dollar_price_as_string).to eq('123.45')
    end
  end
end
