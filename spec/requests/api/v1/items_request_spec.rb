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
end
