require 'rails_helper'

describe 'Customer search API' do
  it 'can find one customer by id' do
    c1 = create(:customer)
    c2 = create(:customer)

    get "/api/v1/customers/find?id=#{c2.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['id']).to eq(c2.id)
  end

  it 'can find one customer by id' do
    c1 = create(:customer, first_name: 'Bob')
    c2 = create(:customer, first_name: 'Sue')

    get "/api/v1/customers/find?first_name=#{c2.first_name}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['attributes']['id']).to eq(c2.id)
  end
end
