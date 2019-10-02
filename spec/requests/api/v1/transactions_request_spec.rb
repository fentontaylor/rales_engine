require 'rails_helper'

describe 'Transactions API' do
  it 'can get an index of transactions' do
    transaction_1 = create(:transaction)
    transaction_2 = create(:transaction)
    transaction_3 = create(:transaction)

    get '/api/v1/transactions'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(transaction_1.id.to_s)
    expect(json['data'][0]['type']).to eq('transaction')
    expect(json['data'][0]['attributes']['id']).to eq(transaction_1.id)
    expect(json['data'][0]['attributes']['invoice_id']).to eq(transaction_1.invoice_id)
    expect(json['data'][0]['attributes']['credit_card_number']).to eq(transaction_1.credit_card_number)
    expect(json['data'][0]['attributes']['result']).to eq(transaction_1.result)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one invoice by its id' do
    transaction = create(:transaction)

    get "/api/v1/transactions/#{transaction.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(transaction.id.to_s)
  end
end
