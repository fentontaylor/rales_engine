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

      result = Merchant.most_revenue(2)
      expect(result).to eq([merchant_3, merchant_2])
    end
  end
end
