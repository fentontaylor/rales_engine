require 'rails_helper'

describe 'Invoices API' do
  it 'can get an index of invoices' do
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_3 = create(:invoice)

    get '/api/v1/invoices'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(invoice_1.id.to_s)
    expect(json['data'][0]['type']).to eq('invoice')
    expect(json['data'][0]['attributes']['id']).to eq(invoice_1.id)
    expect(json['data'][0]['attributes']['customer_id']).to eq(invoice_1.customer_id)
    expect(json['data'][0]['attributes']['merchant_id']).to eq(invoice_1.merchant_id)
    expect(json['data'][0]['attributes']['status']).to eq(invoice_1.status)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one invoice by its id' do
    invoice = create(:invoice)

    get "/api/v1/invoices/#{invoice.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(invoice.id.to_s)
  end

  it 'can get an index of associated transactions' do
    invoice = create(:invoice)
    transaction_1 = create(:transaction, invoice: invoice)
    transaction_2 = create(:transaction, invoice: invoice)
    transaction_3 = create(:transaction, invoice: invoice)
    transaction_4 = create(:transaction)

    get "/api/v1/invoices/#{invoice.id}/transactions"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    ids = [transaction_1, transaction_2, transaction_3].map { |t| t.id.to_s }

    json['data'].each do |t|
      expect(ids.include?(t['id'])).to be true
    end

    result = json['data'].none? do |t|
      t['id'] == transaction_4.id.to_s
    end

    expect(result).to be true
  end

  it 'can get an index of associated invoice_items' do
    invoice = create(:invoice)
    invoice_item_1 = create(:invoice_item, invoice: invoice)
    invoice_item_2 = create(:invoice_item, invoice: invoice)
    invoice_item_3 = create(:invoice_item)

    get "/api/v1/invoices/#{invoice.id}/invoice_items"

    expect(response).to be_successful

    json = JSON.parse(response.body)
    ids = [invoice_item_1, invoice_item_2].map { |ii| ii.id.to_s }

    json['data'].each do |inv_item|
      expect(ids.include?(inv_item['id'])).to be true
    end

    result = json['data'].none? do |inv_item|
      inv_item['id'] == invoice_item_3.id.to_s
    end

    expect(result).to be true
  end

  it 'can get an index of associated items' do
    invoice = create(:invoice)
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)
    invoice_item_1 = create(:invoice_item, invoice: invoice, item: item_1)
    invoice_item_2 = create(:invoice_item, invoice: invoice, item: item_2)
    invoice_item_3 = create(:invoice_item, item: item_3)

    get "/api/v1/invoices/#{invoice.id}/items"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    ids = [item_1, item_2].map { |i| i.id.to_s }

    json['data'].each do |item|
      expect(ids.include?(item['id'])).to be true
    end

    result = json['data'].none? do |item|
      item['id'] == item_3.id.to_s
    end

    expect(result).to be true
  end

  it 'can get the associated customer' do
    customer = create(:customer)
    invoice = create(:invoice, customer: customer)

    get "/api/v1/invoices/#{invoice.id}/customer"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(customer.id.to_s)
    expect([json['data']].count).to eq(1)
  end

  it 'can get the associated merchant' do
    merchant = create(:merchant)
    invoice = create(:invoice, merchant: merchant)

    get "/api/v1/invoices/#{invoice.id}/merchant"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(merchant.id.to_s)
    expect([json['data']].count).to eq(1)
  end
end
