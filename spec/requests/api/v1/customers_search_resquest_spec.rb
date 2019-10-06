require 'rails_helper'

describe 'Customer search API' do
  describe 'single finders' do
    it 'can find one customer by id' do
      c1 = create(:customer)
      c2 = create(:customer)

      get "/api/v1/customers/find?id=#{c2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(c2.id)
    end

    it 'can find one customer by first_name' do
      c1 = create(:customer, first_name: 'Bob')
      c2 = create(:customer, first_name: 'Sue')

      get "/api/v1/customers/find?first_name=#{c2.first_name}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(c2.id)
    end

    it 'can find one customer by last_name' do
      c1 = create(:customer, last_name: 'Bob')
      c2 = create(:customer, last_name: 'Sue')

      get "/api/v1/customers/find?last_name=#{c2.last_name}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(c2.id)
    end

    it 'can find one customer by created_at' do
      c1 = create(:customer, created_at: '2017-05-23 09:04:34 UTC')
      c2 = create(:customer, created_at: '2017-05-25 09:04:34 UTC')

      get "/api/v1/customers/find?created_at=2017-05-25T09:04:34Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(c2.id)
    end

    it 'can find one customer by updated_at' do
      c1 = create(:customer, updated_at: '2017-05-23 09:04:34 UTC')
      c2 = create(:customer, updated_at: '2017-05-25 09:04:34 UTC')

      get "/api/v1/customers/find?updated_at=2017-05-25T09:04:34Z"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data']['attributes']['id']).to eq(c2.id)
    end
  end

  describe 'multi finders' do
    it 'can find all customers by id' do
      c1 = create(:customer)
      c2 = create(:customer)

      get "/api/v1/customers/find_all?id=#{c2.id}"

      expect(response).to be_successful

      json = JSON.parse(response.body)

      expect(json['data'][0]['attributes']['id']).to eq(c2.id)
    end
  end
end
