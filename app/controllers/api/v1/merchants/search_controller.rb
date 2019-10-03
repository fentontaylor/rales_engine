class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.find_by( search_params )
    render json: MerchantSerializer.new( merchant )
  end

  private

  def search_params
    params.permit(:id)
  end
end
