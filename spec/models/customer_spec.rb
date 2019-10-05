require 'rails_helper'

describe Customer do
  describe 'validations' do
    it { should validate_presence_of :first_name }
    it { should validate_presence_of :last_name }
  end

  describe 'relationships' do
    it { should have_many :invoices }
    it { should have_many(:invoice_items).through(:invoices) }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:transactions).through(:invoices) }
  end

  describe 'instance methods' do
    it '#favorite merchant' do
      bob = create(:customer, first_name: 'Bob')

      # merchant_1: num_transactions = 1
      merchant_1 = create(:merchant)
      invoice_1 = create(:invoice, customer: bob, merchant: merchant_1)
      create(:transaction, invoice: invoice_1)

      # merchant_2: num_transactions = 2
      merchant_2 = create(:merchant)
      invoice_2 = create(:invoice, customer: bob, merchant: merchant_2)
      invoice_3 = create(:invoice, customer: bob, merchant: merchant_2)
      create(:transaction, invoice: invoice_2)
      create(:transaction, invoice: invoice_3)

      # merchant_3: num_transactions = 1
      merchant_3 = create(:merchant)
      invoice_4 = create(:invoice, customer: bob, merchant: merchant_3)
      invoice_5 = create(:invoice, customer: bob, merchant: merchant_3)
      invoice_6 = create(:invoice, customer: bob, merchant: merchant_3)
      create(:transaction, invoice: invoice_4, result: 'failed')
      create(:transaction, invoice: invoice_5, result: 'failed')
      create(:transaction, invoice: invoice_6)

      expect(bob.favorite_merchant).to eq(merchant_2)
    end
  end
end
