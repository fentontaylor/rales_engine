require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { should validate_presence_of :name }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    it '::most_revenue' do
      # has one huge sale, but the transaction failed
      merchant_1 = create(:merchant)
      invoice_1 = create(:invoice, merchant: merchant_1)
      create(:invoice_item, invoice: invoice_1, unit_price: 1000000)
      create(:transaction, invoice: invoice_1, result: 'failed')

      # has 2 small sales, 2nd place
      merchant_2 = create(:merchant)
      invoice_2 = create(:invoice, merchant: merchant_2)
      invoice_3 = create(:invoice, merchant: merchant_2)
      create(:invoice_item, invoice: invoice_2)
      create(:invoice_item, invoice: invoice_3)
      create(:transaction, invoice: invoice_2, result: 'success')
      create(:transaction, invoice: invoice_3, result: 'success')

      # has 2 medium sales, 1st place
      merchant_3 = create(:merchant)
      invoice_4 = create(:invoice, merchant: merchant_3)
      invoice_5 = create(:invoice, merchant: merchant_3)
      create(:invoice_item, invoice: invoice_4, quantity: 4)
      create(:invoice_item, invoice: invoice_5, quantity: 5)
      create(:transaction, invoice: invoice_4, result: 'success')
      create(:transaction, invoice: invoice_5, result: 'success')

      expect( Merchant.most_revenue(2) ).to eq([merchant_3, merchant_2])

      expect( Merchant.most_revenue(1) ).to eq([merchant_3])
    end

    it '::revenue' do
      merchant_1 = create(:merchant)
      merchant_2 = create(:merchant)

      invoice_1 = create(:invoice, merchant: merchant_1, created_at: '2019-10-02')
      invoice_2 = create(:invoice, merchant: merchant_2, created_at: '2019-10-02')
      invoice_3 = create(:invoice, merchant: merchant_2, created_at: '2019-10-02')

      create(:invoice_item, invoice: invoice_1, quantity: 2, unit_price: 1000)
      create(:invoice_item, invoice: invoice_2, quantity: 1, unit_price: 5000)
      create(:invoice_item, invoice: invoice_3, quantity: 1, unit_price: 9999)

      create(:transaction, invoice: invoice_1)
      create(:transaction, invoice: invoice_2)
      create(:transaction, invoice: invoice_3, result: 'failed')

      expect(Merchant.revenue('2019-10-02')).to eq({'total_revenue' => 7000})
    end

    it '::find_by_lower_name' do
      merchant = create(:merchant, name: 'Bob Shop')
      merchant_2 = create(:merchant, name: 'Bob Shop 2')

      expect(Merchant.find_by_lower_name('Bob Shop', all: false)).to eq(merchant)
      expect(Merchant.find_by_lower_name('bob shop', all: false)).to eq(merchant)
      expect(Merchant.find_by_lower_name('BOB SHOP', all: false)).to eq(merchant)

      expect(Merchant.find_by_lower_name('bob shop')).to eq([merchant, merchant_2])

      expect(Merchant.find_by_lower_name('bob')).to eq([merchant, merchant_2])
    end

    it '::find_by_flex_date' do
      ignore = create(:merchant)
      merchant = create(:merchant, name: 'Bob Shop', created_at: '2019-10-03 09:34:45 UTC')

      expect(Merchant.find_by_flex_date(created_at: '2019-10-03T09:34:45Z'))
    end
  end

  describe 'instance methods' do
    it '#favorite_customer' do
      merchant = create(:merchant)

      # 1 successful transaction
      customer_1 = create(:customer)
      invoice_1 = create(:invoice, merchant: merchant, customer: customer_1)
      create(:transaction, invoice: invoice_1)

      # 3 successful transactions
      customer_2 = create(:customer)
      invoice_2 = create(:invoice, merchant: merchant, customer: customer_2)
      invoice_3 = create(:invoice, merchant: merchant, customer: customer_2)
      invoice_4 = create(:invoice, merchant: merchant, customer: customer_2)
      create(:transaction, invoice: invoice_2)
      create(:transaction, invoice: invoice_3)
      create(:transaction, invoice: invoice_4)

      # 2 successful transactions, 2 failed
      customer_3 = create(:customer)
      invoice_5 = create(:invoice, merchant: merchant, customer: customer_3)
      invoice_6 = create(:invoice, merchant: merchant, customer: customer_3)
      invoice_7 = create(:invoice, merchant: merchant, customer: customer_3)
      invoice_8 = create(:invoice, merchant: merchant, customer: customer_3)
      create(:transaction, invoice: invoice_5)
      create(:transaction, invoice: invoice_6)
      create(:transaction, invoice: invoice_7, result: 'failed')
      create(:transaction, invoice: invoice_8, result: 'failed')

      expect(merchant.favorite_customer).to eq(customer_2)
    end
  end
end
