require 'rails_helper'

describe 'Invoice Items search API' do
  describe 'single finders' do
    it 'can find one invoice_item by id' do
      ii1 = create(:invoice_item)
      ii2 = create(:invoice_item)

      get "/api/v1/invoice_items/find?id=#{ii2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end

    it 'can find one invoice_item by item_id' do
      item1 = create(:item)
      item2 = create(:item)
      ii1 = create(:invoice_item, item: item1)
      ii2 = create(:invoice_item, item: item2)

      get "/api/v1/invoice_items/find?item_id=#{item2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end

    it 'can find one invoice_item by invoice_id' do
      inv1 = create(:invoice)
      inv2 = create(:invoice)
      ii1 = create(:invoice_item, invoice: inv1)
      ii2 = create(:invoice_item, invoice: inv2)

      get "/api/v1/invoice_items/find?invoice_id=#{inv2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end

    it 'can find one invoice_item by quantity' do
      ii1 = create(:invoice_item, quantity: 1)
      ii2 = create(:invoice_item, quantity: 2)

      get "/api/v1/invoice_items/find?quantity=2"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end

    it 'can find one invoice_item by unit_price' do
      ii1 = create(:invoice_item, unit_price: 1000)
      ii2 = create(:invoice_item, unit_price: 2000)

      get "/api/v1/invoice_items/find?unit_price=20.00"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end

    it 'can find one invoice_item by created_at' do
      ii1 = create(:invoice_item, created_at: '2016-09-08 12:23:23 UTC')
      ii2 = create(:invoice_item, created_at: '2016-10-08 12:23:23 UTC')

      get "/api/v1/invoice_items/find?created_at=2016-10-08T12:23:23Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end

    it 'can find one invoice_item by updated_at' do
      ii1 = create(:invoice_item, updated_at: '2016-09-08 12:23:23 UTC')
      ii2 = create(:invoice_item, updated_at: '2016-10-08 12:23:23 UTC')

      get "/api/v1/invoice_items/find?updated_at=2016-10-08T12:23:23Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(ii2.id)
    end
  end

  describe 'multi finders' do
    it 'can find all invoice_items by id' do
      ii1 = create(:invoice_item)
      ii2 = create(:invoice_item)

      get "/api/v1/invoice_items/find_all?id=#{ii2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii2.id)
    end

    it 'can find all invoice_items by item_id' do
      item = create(:item)
      ii1 = create(:invoice_item, item: item)
      ii2 = create(:invoice_item, item: item)

      get "/api/v1/invoice_items/find_all?item_id=#{item.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii1.id)
      expect(json['data'][1]['attributes']['id']).to eq(ii2.id)
    end

    it 'can find all invoice_items by invoice_id' do
      invoice = create(:invoice)
      ii1 = create(:invoice_item, invoice: invoice)
      ii2 = create(:invoice_item, invoice: invoice)

      get "/api/v1/invoice_items/find_all?invoice_id=#{invoice.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii1.id)
      expect(json['data'][1]['attributes']['id']).to eq(ii2.id)
    end

    it 'can find all invoice_items by quantity' do
      ii1 = create(:invoice_item, quantity: 2)
      ii2 = create(:invoice_item, quantity: 2)

      get "/api/v1/invoice_items/find_all?quantity=2"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii1.id)
      expect(json['data'][1]['attributes']['id']).to eq(ii2.id)
    end

    it 'can find all invoice_items by unit_price' do
      ii1 = create(:invoice_item, unit_price: 2000)
      ii2 = create(:invoice_item, unit_price: 2000)

      get "/api/v1/invoice_items/find_all?unit_price=20.00"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii1.id)
      expect(json['data'][1]['attributes']['id']).to eq(ii2.id)
    end

    it 'can find all invoice_items by created_at' do
      ii1 = create(:invoice_item, created_at: '2018-08-02 12:23:34 UTC')
      ii2 = create(:invoice_item, created_at: '2018-08-02 12:23:34 UTC')

      get "/api/v1/invoice_items/find_all?created_at=2018-08-02T12:23:34Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii1.id)
      expect(json['data'][1]['attributes']['id']).to eq(ii2.id)
    end

    it 'can find all invoice_items by updated_at' do
      ii1 = create(:invoice_item, updated_at: '2018-08-02 12:23:34 UTC')
      ii2 = create(:invoice_item, updated_at: '2018-08-02 12:23:34 UTC')

      get "/api/v1/invoice_items/find_all?updated_at=2018-08-02T12:23:34Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(ii1.id)
      expect(json['data'][1]['attributes']['id']).to eq(ii2.id)
    end
  end
end
