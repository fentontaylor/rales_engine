require 'rails_helper'

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body)
    binding.pry
    expect(merchants.count).to eq(3)
  end

  it 'can get one item by its id' do

  end
end
