require 'rails_helper'

describe 'Merchants API' do
  it 'can find one merchant by id' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?id=#{merchant_2.id}"

    expect(response).to be_successful

    json = JSON.parse (response.body)

    expect(json['data']['id']).to eq(merchant_2.id.to_s)
    expect([json['data']].count).to eq(1)
  end

  it 'can find one merchant by name' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant)

    get "/api/v1/merchants/find?name=#{merchant_2.name}"

    expect(response).to be_successful

    json = JSON.parse (response.body)
    expect(json['data']['id']).to eq(merchant_2.id.to_s)
    expect([json['data']].count).to eq(1)

    get "/api/v1/merchants/find?name=#{merchant_2.name.downcase}"

    expect(response).to be_successful

    json = JSON.parse (response.body)

    expect(json['data']['id']).to eq(merchant_2.id.to_s)
    expect([json['data']].count).to eq(1)
  end

  it 'can find one merchant by created_at' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant, created_at: '2019-10-03 10:19:23 UTC')

    get "/api/v1/merchants/find?created_at=2019-10-03T10:19:23.000Z"

    expect(response).to be_successful

    json = JSON.parse (response.body)

    expect(json['data']['id']).to eq(merchant_2.id.to_s)
    expect([json['data']].count).to eq(1)
  end

  it 'can find one merchant by updated_at' do
    merchant_1 = create(:merchant)
    merchant_2 = create(:merchant, updated_at: '2019-10-03 10:19:23 UTC')

    get "/api/v1/merchants/find?updated_at=2019-10-03T10:19:23.000Z"

    expect(response).to be_successful

    json = JSON.parse (response.body)

    expect(json['data']['id']).to eq(merchant_2.id.to_s)
    expect([json['data']].count).to eq(1)
  end
end
