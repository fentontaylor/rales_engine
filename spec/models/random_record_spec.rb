require 'rails_helper'

describe 'Random record' do
  it 'can return a random record from customers' do
    10.times { create(:customer) }
    results = []
    10.times { results << Customer.random }

    results.all? do |result|
      expect(result).to be_instance_of(Customer)
    end

    ids = results.pluck(:id)
    expect(ids.all? {|id| id == ids[0]}).to be false
  end

  it 'can return a random record from invoices' do
    10.times { create(:invoice) }
    results = []
    10.times { results << Invoice.random }

    results.all? do |result|
      expect(result).to be_instance_of(Invoice)
    end

    ids = results.pluck(:id)
    expect(ids.all? {|id| id == ids[0]}).to be false
  end

  it 'can return a random record from invoice_items' do
    10.times { create(:invoice_item) }
    results = []
    10.times { results << InvoiceItem.random }

    results.all? do |result|
      expect(result).to be_instance_of(InvoiceItem)
    end

    ids = results.pluck(:id)
    expect(ids.all? {|id| id == ids[0]}).to be false
  end

  it 'can return a random record from items' do
    10.times { create(:item) }
    results = []
    10.times { results << Item.random }

    results.all? do |result|
      expect(result).to be_instance_of(Item)
    end

    ids = results.pluck(:id)
    expect(ids.all? {|id| id == ids[0]}).to be false
  end

  it 'can return a random record from merchants' do
    10.times { create(:merchant) }
    results = []
    10.times { results << Merchant.random }

    results.all? do |result|
      expect(result).to be_instance_of(Merchant)
    end

    ids = results.pluck(:id)
    expect(ids.all? {|id| id == ids[0]}).to be false
  end

  it 'can return a random record from transactions' do
    10.times { create(:transaction) }
    results = []
    10.times { results << Transaction.random }

    results.all? do |result|
      expect(result).to be_instance_of(Transaction)
    end

    ids = results.pluck(:id)
    expect(ids.all? {|id| id == ids[0]}).to be false
  end
end
