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

  describe 'class methods' do
    it '::search' do
      time = '2019-10-05T19:36:45Z'
      invoice = create(:invoice)
      item1 = create(:item)
      item2 = create(:item)

      inv_item1 = create(:invoice_item,
        invoice: invoice,
        item: item1,
        quantity: 1,
        unit_price: 1799,
        created_at: time
      )

      inv_item2 = create(:invoice_item,
        invoice: invoice,
        item: item2,
        quantity: 2,
        unit_price: 2395,
        created_at: time
      )

      result = InvoiceItem.search({'unit_price' => '17.99'})
      expect(result).to eq(inv_item1)

      result = InvoiceItem.search({'invoice_id' => invoice.id}, multiple: true)
      expect(result).to eq([inv_item1, inv_item2])
    end
  end

  describe 'instance methods' do
    it '#dollar_price_as_string' do
      invoice_item = create(:invoice_item, unit_price: 12345)

      expect(invoice_item.dollar_price_as_string).to eq('123.45')
    end
  end
end
