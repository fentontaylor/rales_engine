class Api::V1::Customers::FavoriteMerchantController < ApplicationController
  def show
    customer = Customer.find_by_id(params[:id])
    render json: MerchantSerializer.new(customer.favorite_merchant)
  end
end
