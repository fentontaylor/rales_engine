require 'rails_helper'

describe 'Transactions Search API' do
  describe 'single-finders' do
    it 'can find one transaction by id' do
      t1 = create(:transaction)
      t2 = create(:transaction)

      get "/api/v1/transactions/find?id=#{t2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(t2.id)
    end

    it 'can find one transaction by invoice_id' do
      i1 = create(:invoice)
      i2 = create(:invoice)
      t1 = create(:transaction, invoice: i1)
      t2 = create(:transaction, invoice: i2)

      get "/api/v1/transactions/find?invoice_id=#{i2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(t2.id)
    end

    it 'can find one transaction by credit_card_number' do
      t1 = create(:transaction)
      t2 = create(:transaction, credit_card_number: "1234123412341234")

      get "/api/v1/transactions/find?credit_card_number=1234123412341234"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(t2.id)
    end

    it 'can find one transaction by result' do
      t1 = create(:transaction, result: 'failed')
      t2 = create(:transaction, result: 'success')

      get "/api/v1/transactions/find?result=success"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(t2.id)
    end

    it 'can find one transaction by created_at' do
      t1 = create(:transaction, created_at: '2013-04-04 12:12:12 UTC')
      t2 = create(:transaction, created_at: '2013-04-05 12:12:12 UTC')

      get "/api/v1/transactions/find?created_at=2013-04-05T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(t2.id)
    end

    it 'can find one transaction by updated_at' do
      t1 = create(:transaction, updated_at: '2013-04-04 12:12:12 UTC')
      t2 = create(:transaction, updated_at: '2013-04-05 12:12:12 UTC')

      get "/api/v1/transactions/find?updated_at=2013-04-05T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(t2.id)
    end
  end

  describe 'multi-finders' do
    it 'can find all transactions by id' do
      t1 = create(:transaction)
      t2 = create(:transaction)

      get "/api/v1/transactions/find_all?id=#{t2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(t2.id)
    end

    it 'can find all transactions by invoice_id' do
      i1 = create(:invoice)
      t1 = create(:transaction, invoice: i1, result: 'failed')
      t2 = create(:transaction, invoice: i1, result: 'success')

      get "/api/v1/transactions/find_all?invoice_id=#{i1.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(t1.id)
      expect(json['data'][1]['attributes']['id']).to eq(t2.id)
    end

    it 'can find all transactions by credit_card_number' do
      t1 = create(:transaction, credit_card_number: "1234123412341234")
      t2 = create(:transaction, credit_card_number: "1234123412341234")

      get "/api/v1/transactions/find_all?credit_card_number=1234123412341234"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(t1.id)
      expect(json['data'][1]['attributes']['id']).to eq(t2.id)
    end

    it 'can find all transactions by result' do
      t1 = create(:transaction, result: 'success')
      t2 = create(:transaction, result: 'success')
      t3 = create(:transaction, result: 'failed')

      get "/api/v1/transactions/find_all?result=success"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(t1.id)
      expect(json['data'][1]['attributes']['id']).to eq(t2.id)
    end

    it 'can find all transactions by created_at' do
      t1 = create(:transaction, created_at: '2012-09-09 12:12:12 UTC')
      t2 = create(:transaction, created_at: '2012-09-09 12:12:12 UTC')
      t3 = create(:transaction, created_at: '2012-02-09 12:12:14 UTC')

      get "/api/v1/transactions/find_all?created_at=2012-09-09T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(t1.id)
      expect(json['data'][1]['attributes']['id']).to eq(t2.id)
    end

    it 'can find all transactions by updated_at' do
      t1 = create(:transaction, updated_at: '2012-09-09 12:12:12 UTC')
      t2 = create(:transaction, updated_at: '2012-09-09 12:12:12 UTC')
      t3 = create(:transaction, updated_at: '2012-02-09 12:12:14 UTC')

      get "/api/v1/transactions/find_all?updated_at=2012-09-09T12:12:12Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(t1.id)
      expect(json['data'][1]['attributes']['id']).to eq(t2.id)
    end
  end
end
