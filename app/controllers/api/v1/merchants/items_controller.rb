class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    merchant = Merchant.find_by_id(params[:merchant_id])
    render json: ItemSerializer.new(merchant.items)
  end
end
