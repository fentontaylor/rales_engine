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
end
