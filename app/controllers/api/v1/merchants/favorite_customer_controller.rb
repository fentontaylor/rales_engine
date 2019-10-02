class Api::V1::Merchants::FavoriteCustomerController < ApplicationController
  def show
    merchant = Merchant.find_by_id(params[:id])
    render json: CustomerSerializer.new(merchant.favorite_customer) if merchant
  end
end
