require 'rails_helper'

describe 'Invoices Search API' do
  describe 'single finders' do
    it 'can find one invoice by id' do
      i1 = create(:invoice)
      i2 = create(:invoice)

      get "/api/v1/invoices/find?id=#{i2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one invoice by customer_id' do
      c1 = create(:customer)
      c2 = create(:customer)
      i1 = create(:invoice, customer: c1)
      i2 = create(:invoice, customer: c2)

      get "/api/v1/invoices/find?customer_id=#{c2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one invoice by merchant_id' do
      m1 = create(:merchant)
      m2 = create(:merchant)
      i1 = create(:invoice, merchant: m1)
      i2 = create(:invoice, merchant: m2)

      get "/api/v1/invoices/find?merchant_id=#{m2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one invoice by status' do
      i1 = create(:invoice, status: 'shipped')
      i2 = create(:invoice, status: 'shipped')

      get "/api/v1/invoices/find?status=shipped"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i1.id)
    end

    it 'can find one invoice by created_at' do
      i1 = create(:invoice, created_at: '2012-12-12 12:12:12 UTC')
      i2 = create(:invoice, created_at: '2012-12-13 12:12:12 UTC')

      get "/api/v1/invoices/find?created_at=2012-12-13T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end

    it 'can find one invoice by updated_at' do
      i1 = create(:invoice, updated_at: '2012-12-12 12:12:12 UTC')
      i2 = create(:invoice, updated_at: '2012-12-13 12:12:12 UTC')

      get "/api/v1/invoices/find?updated_at=2012-12-13T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(i2.id)
    end
  end
end
