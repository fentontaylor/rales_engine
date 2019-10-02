require 'rails_helper'

describe 'InvoiceItems API' do
  it 'can get an index of invoice_items' do
    invoice_item_1 = create(:invoice_item)
    invoice_item_2 = create(:invoice_item)
    invoice_item_3 = create(:invoice_item)

    get '/api/v1/invoice_items'

    expect(response).to be_successful

    json = JSON.parse(response.body)

    first = json['data'][0]

    expect(first['id']).to eq(invoice_item_1.id.to_s)
    expect(first['type']).to eq('invoice_item')
    expect(first['attributes']['id']).to eq(invoice_item_1.id)
    expect(first['attributes']['invoice_id']).to eq(invoice_item_1.invoice_id)
    expect(first['attributes']['item_id']).to eq(invoice_item_1.item_id)
    expect(first['attributes']['quantity']).to eq(invoice_item_1.quantity)
    expect(first['attributes']['unit_price']).to eq(invoice_item_1.unit_price)

    expect(json['data'].count).to eq(3)
  end

  it 'can show one invoice by its id' do
    invoice_item = create(:invoice_item)

    get "/api/v1/invoice_items/#{invoice_item.id}"

    expect(response).to be_successful

    json = JSON.parse(response.body)

    expect(json['data']['id']).to eq(invoice_item.id.to_s)
  end
end
