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
end
