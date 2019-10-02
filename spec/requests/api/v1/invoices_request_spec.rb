require 'rails_helper'

describe 'Invoices API' do
  it 'can get an index of invoices' do
    invoice_1 = create(:invoice)
    invoice_2 = create(:invoice)
    invoice_3 = create(:invoice)

    get '/api/v1/invoices'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data'][0]['id']).to eq(invoice_1.id.to_s)
    expect(json['data'][0]['type']).to eq('invoice')
    expect(json['data'][0]['attributes']['id']).to eq(invoice_1.id)
    expect(json['data'][0]['attributes']['customer_id']).to eq(invoice_1.customer_id)
    expect(json['data'][0]['attributes']['merchant_id']).to eq(invoice_1.merchant_id)
    expect(json['data'][0]['attributes']['status']).to eq(invoice_1.status)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one invoice by its id' do
    invoice = create(:invoice)

    get "/api/v1/invoices/#{invoice.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(invoice.id.to_s)
  end
end
