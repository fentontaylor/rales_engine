require 'rails_helper'

describe 'Items Search API' do
  describe 'single finders' do
    it 'can find one item by id' do
      i1 = create(:item)
      i2 = create(:item)

      get "/api/v1/items/find?id=#{i2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one item by name' do
      i1 = create(:item, name: 'thing')
      i2 = create(:item, name: 'widget')

      get "/api/v1/items/find?name=widget"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one item by description' do
      i1 = create(:item, description: 'its a thing')
      i2 = create(:item, description: 'its a widget')

      get "/api/v1/items/find?description=its a widget"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one item by unit_price' do
      i1 = create(:item, unit_price: 2000)
      i2 = create(:item, unit_price: 27409)

      get "/api/v1/items/find?unit_price=274.09"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one item by merchant_id' do
      m1 = create(:merchant)
      m2 = create(:merchant)
      i1 = create(:item, merchant: m1)
      i2 = create(:item, merchant: m2)

      get "/api/v1/items/find?merchant_id=#{m2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one item by created_at' do
      i1 = create(:item, created_at: '2012-12-12 12:12:12 UTC')
      i2 = create(:item, created_at: '2012-12-13 12:12:12 UTC')

      get "/api/v1/items/find?created_at=2012-12-13T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one item by updated_at' do
      i1 = create(:item, updated_at: '2012-12-12 12:12:12 UTC')
      i2 = create(:item, updated_at: '2012-12-13 12:12:12 UTC')

      get "/api/v1/items/find?updated_at=2012-12-13T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

  end
end
