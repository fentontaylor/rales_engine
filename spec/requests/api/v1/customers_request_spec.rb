require 'rails_helper'

describe 'Customers API' do
  it 'can get an index of customers' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get '/api/v1/customers'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(customer_1.id.to_s)
    expect(json['data'][0]['type']).to eq('customer')
    expect(json['data'][0]['attributes']['id']).to eq(customer_1.id)
    expect(json['data'][0]['attributes']['first_name']).to eq(customer_1.first_name)
    expect(json['data'][0]['attributes']['last_name']).to eq(customer_1.last_name)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one invoice by its id' do
    customer = create(:customer)

    get "/api/v1/customers/#{customer.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(customer.id.to_s)
  end

  it 'can return a customers favorite merchant' do
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

    get "/api/v1/customers/#{bob.id}/favorite_merchant"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['id']).to eq(merchant_2.id)
    expect(json['data']['attributes']['name']).to eq(merchant_2.name)
  end

  it 'can get an index of associated invoices' do
    sue = create(:customer)
    inv_1 = create(:invoice, customer: sue)
    inv_2 = create(:invoice, customer: sue)
    inv_3 = create(:invoice, customer: sue)
    not_for_sue = create(:invoice)

    get "/api/v1/customers/#{sue.id}/invoices"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'].count).to eq(3)

    ids = [inv_1, inv_2, inv_3].map { |inv| inv.id.to_s }

    json['data'].each do |inv|
      expect(ids.include?(inv['id'])).to be true
    end

    result = json['data'].none? do |inv|
      inv['id'] == not_for_sue.id.to_s
    end
  end

  it 'can get an index of associated invoices' do
    sue = create(:customer)
    inv_1 = create(:invoice, customer: sue)
    inv_2 = create(:invoice, customer: sue)
    inv_3 = create(:invoice, customer: sue)
    not_for_sue = create(:invoice)
    t1 = create(:transaction, invoice: inv_1)
    t2 = create(:transaction, invoice: inv_2)
    t3 = create(:transaction, invoice: inv_3)
    t4 = create(:transaction, invoice: not_for_sue)

    get "/api/v1/customers/#{sue.id}/transactions"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'].count).to eq(3)

    ids = [t1, t2, t3].map { |t| t.id.to_s }

    json['data'].each do |t|
      expect(ids.include?(t['id'])).to be true
    end

    result = json['data'].none? do |t|
      t['id'] == t4.id.to_s
    end
  end

  it 'can return a random merchant' do
    c1 = create(:customer)
    c2 = create(:customer)
    c3 = create(:customer)

    get '/api/v1/customers/random'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    ids = [c1, c2, c3].map { |c| c.id }
    result = json['data']['attributes']['id']

    expect(ids.include? result).to be true
  end
end
