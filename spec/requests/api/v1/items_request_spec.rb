require 'rails_helper'

describe 'Items API' do
  it 'can get an index of items' do
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)

    get '/api/v1/items'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(item_1.id.to_s)
    expect(json['data'][0]['type']).to eq('item')
    expect(json['data'][0]['attributes']['id']).to eq(item_1.id)
    expect(json['data'][0]['attributes']['name']).to eq(item_1.name)
    expect(json['data'][0]['attributes']['description']).to eq(item_1.description)
    expect(json['data'][0]['attributes']['merchant_id']).to eq(item_1.merchant_id)
    expect(json['data'][0]['attributes']['unit_price']).to eq(item_1.unit_price)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one item by id' do
    item = create(:item)

    get "/api/v1/items/#{item.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(item.id.to_s)
  end

  it 'can return all of its associated invoice_items' do
    item = create(:item)

    ii_1 = create(:invoice_item, item: item)
    ii_2 = create(:invoice_item, item: item)
    ii_3 = create(:invoice_item, item: item)
    ii_4 = create(:invoice_item)

    get "/api/v1/items/#{item.id}/invoice_items"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    ids = [ii_1, ii_2, ii_3].map { |ii| ii.id.to_s }

    json['data'].each do |ii|
      expect(ids.include?(ii['id'])).to be true
    end

    result = json['data'].none? do |ii|
      ii['id'] == ii_4.id.to_s
    end
  end

  it 'can return all of its associated invoice_items' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    item_1 = create(:item, merchant: merchant_1)
    item_2 = create(:item, merchant: merchant_2)

    get "/api/v1/items/#{item_1.id}/merchant"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['id']).to eq(merchant_1.id)
    expect(json['data']['attributes']['name']).to eq(merchant_1.name)
  end

  it 'can return the top x items ranked by total revenue' do
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

    get "/api/v1/items/most_revenue?quantity=1"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'].first['id']).to eq(item_3.id.to_s)


    get "/api/v1/items/most_revenue?quantity=3"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(item_3.id.to_s)
    expect(json['data'][1]['id']).to eq(item_4.id.to_s)
    expect(json['data'][2]['id']).to eq(item_2.id.to_s)
  end

  it 'can return the date of an items best sales' do
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

    get "/api/v1/items/#{item.id}/best_day"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['attributes']).to eq({"best_day" => "2019-10-03"})
  end
end
