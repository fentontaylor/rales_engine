class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = Merchant.search( search_params )
    render json: MerchantSerializer.new( merchant )
  end

  def index
    merchant = Merchant.search( search_params, multiple: true)
    render json: MerchantSerializer.new( merchant )
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
