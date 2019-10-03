require 'rails_helper'

describe 'Merchants API' do
  it 'can find one merchant by id' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant_1.id}"

    expect(response).to be_successful

    json = JSON.parse (response.body)
    
    expect(json['data']['id']).to eq(merchant_1.id.to_s)
    expect([json['data']].count).to eq(1)
  end
end
