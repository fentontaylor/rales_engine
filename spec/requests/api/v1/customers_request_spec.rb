require 'rails_helper'

describe 'Customers API' do
  it 'can get an index of customers' do
    customer_1 = create(:customer)
    customer_2 = create(:customer)
    customer_3 = create(:customer)

    get '/api/v1/customers'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(customer_1.id.to_s)
    expect(json['data'][0]['type']).to eq('customer')
    expect(json['data'][0]['attributes']['id']).to eq(customer_1.id)
    expect(json['data'][0]['attributes']['first_name']).to eq(customer_1.first_name)
    expect(json['data'][0]['attributes']['last_name']).to eq(customer_1.last_name)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one invoice by its id' do
    customer = create(:customer)

    get "/api/v1/customers/#{customer.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(customer.id.to_s)
  end
end
