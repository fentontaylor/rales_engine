require 'rails_helper'

describe Item do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :merchant_id }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'class methods' do
    it '::most_revenue' do
      item_1 = create(:item, unit_price: 1000)
      item_2 = create(:item, unit_price: 1000)
      item_3 = create(:item, unit_price: 1000)
      item_4 = create(:item, unit_price: 1000)

      # item_1: total_revenue = 2000
      invoice_1 = create(:invoice)
      invoice_2 = create(:invoice)
      create(:invoice_item, invoice: invoice_1, item: item_1, quantity: 1)
      create(:invoice_item, invoice: invoice_2, item: item_1, quantity: 1)
      create(:transaction, invoice: invoice_1)
      create(:transaction, invoice: invoice_2)

      # item_2: total_revenue = 3000
      invoice_3 = create(:invoice)
      invoice_4 = create(:invoice)
      invoice_7 = create(:invoice)
      create(:invoice_item, invoice: invoice_3, item: item_2, quantity: 1)
      create(:invoice_item, invoice: invoice_4, item: item_2, quantity: 2)
      create(:invoice_item, invoice: invoice_7, item: item_2, quantity: 10)
      create(:transaction, invoice: invoice_3)
      create(:transaction, invoice: invoice_4)
      create(:transaction, invoice: invoice_7, result: 'failed')

      # item_3: total_revenue = 5000
      invoice_5 = create(:invoice)
      invoice_6 = create(:invoice)
      create(:invoice_item, invoice: invoice_5, item: item_3, quantity: 3)
      create(:invoice_item, invoice: invoice_6, item: item_3, quantity: 2)
      create(:transaction, invoice: invoice_5)
      create(:transaction, invoice: invoice_6)

      # item_4: total_revenue = 4000
      invoice_8 = create(:invoice)
      invoice_9 = create(:invoice)
      invoice_10 = create(:invoice)
      create(:invoice_item, invoice: invoice_8, item: item_4, quantity: 2)
      create(:invoice_item, invoice: invoice_9, item: item_4, quantity: 2)
      create(:invoice_item, invoice: invoice_10, item: item_4, quantity: 8)
      create(:transaction, invoice: invoice_8)
      create(:transaction, invoice: invoice_9)
      create(:transaction, invoice: invoice_10, result: 'failed')

      expect(Item.most_revenue(1)).to eq([item_3])
      expect(Item.most_revenue(2)).to eq([item_3, item_4])
      expect(Item.most_revenue(3)).to eq([item_3, item_4, item_2])
    end
  end

  describe 'instance methods' do
    it '#best_day' do
      item = create(:item, unit_price: 1000)

      # day_1: num_sold = 1
      invoice_1 = create(:invoice, created_at: '2019-10-05 12:34:56 UTC')
      create(:invoice_item, invoice: invoice_1, item: item, quantity: 1)
      create(:transaction, invoice: invoice_1)

      # day_2: num_sold = 2
      invoice_2 = create(:invoice, created_at: '2019-10-04 12:34:56 UTC')
      invoice_3 = create(:invoice, created_at: '2019-10-04 12:34:56 UTC')
      create(:invoice_item, invoice: invoice_2, item: item, quantity: 1)
      create(:invoice_item, invoice: invoice_3, item: item, quantity: 1)
      create(:transaction, invoice: invoice_2)
      create(:transaction, invoice: invoice_3)

      # day_3: num_sold = 4
      invoice_4 = create(:invoice, created_at: '2019-10-03 12:34:56 UTC')
      invoice_5 = create(:invoice, created_at: '2019-10-03 12:34:56 UTC')
      create(:invoice_item, invoice: invoice_4, item: item, quantity: 2)
      create(:invoice_item, invoice: invoice_5, item: item, quantity: 2)
      create(:transaction, invoice: invoice_4)
      create(:transaction, invoice: invoice_5)

      # day_4: num_sold = 3
      invoice_6 = create(:invoice, created_at: '2019-10-01 12:34:56 UTC')
      invoice_7 = create(:invoice, created_at: '2019-10-01 12:34:56 UTC')
      invoice_8 = create(:invoice, created_at: '2019-10-01 12:34:56 UTC')
      create(:invoice_item, invoice: invoice_6, item: item, quantity: 1)
      create(:invoice_item, invoice: invoice_7, item: item, quantity: 2)
      create(:invoice_item, invoice: invoice_8, item: item, quantity: 2)
      create(:transaction, invoice: invoice_6)
      create(:transaction, invoice: invoice_7)
      create(:transaction, invoice: invoice_8, result: 'failed')

      expect(item.best_day).to eq({"best_day" => "2019-10-03"})
    end
  end
end
