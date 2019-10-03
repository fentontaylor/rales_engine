require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)
    merchant_3 = create(:merchant)

    get '/api/v1/merchants'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(merchant_1.id.to_s)
    expect(json['data'][0]['type']).to eq('merchant')
    expect(json['data'][0]['attributes']['id']).to eq(merchant_1.id)
    expect(json['data'][0]['attributes']['name']).to eq(merchant_1.name)

    expect(json['data'].count).to eq(3)
  end

  it 'can get one merchant by its id' do
    merchant = create(:merchant)

    get "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(merchant.id.to_s)
  end

  it 'can return the items of a merchant' do
    merchant = create(:merchant)
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)

    merchant.items << item_1
    merchant.items << item_2

    get "/api/v1/merchants/#{merchant.id}/items"

    expect(response).to be_successful

    expect(response.body.include?(item_1.name)).to be true
    expect(response.body.include?(item_2.name)).to be true
    expect(response.body.include?(item_3.name)).to be false
  end

  it 'can return the invoices of a merchant' do
    merchant = create(:merchant)
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_3 = create(:invoice)

    merchant.invoices << invoice_1
    merchant.invoices << invoice_2

    get "/api/v1/merchants/#{merchant.id}/invoices"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'].count).to eq(2)
  end

  it 'can return the top x merchants, ranked by total revenue' do
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

    get "/api/v1/merchants/most_revenue?quantity=2"

    expect(response).to be_successful
    json = JSON.parse(response.body)

    expect(json['data'].first['id']).to eq(merchant_3.id.to_s)
    expect(json['data'][1]['id']).to eq(merchant_2.id.to_s)
    expect(json['data'].count).to eq(2)


    get "/api/v1/merchants/most_revenue?quantity=1"

    json = JSON.parse(response.body)
    expect(json['data'].first['id']).to eq(merchant_3.id.to_s)
    expect(json['data'].count).to eq(1)


    get "/api/v1/merchants/most_revenue?quantity=a"

    json = JSON.parse(response.body)
    expect(json['data']).to eq([])
  end

  it 'can return the total_revenue for all merchants on a given date' do
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

    get "/api/v1/merchants/revenue?date=2019-10-02"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    expect(json['data']['attributes']).to eq({'total_revenue'=>'70.00'})
  end

  it 'can return the customer who has the most successful transactions' do
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

    get "/api/v1/merchants/#{merchant.id}/favorite_customer"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['id']).to eq(customer_2.id)
  end
end
