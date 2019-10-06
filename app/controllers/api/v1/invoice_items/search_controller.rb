class Api::V1::InvoiceItems::SearchController < ApplicationController
  def show
    inv_item = InvoiceItem.search( search_params )
    render json: InvoiceItemSerializer.new( inv_item )
  end

  private

  def search_params
    params.permit(
      :id,
      :item_id,
      :invoice_id,
      :quantity,
      :unit_price,
      :created_at,
      :updated_at )
  end
end
