class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = case search_params.keys.first
    when 'id'
      Merchant.find_by( search_params )
    when 'name'
      Merchant.find_by_lower_name( search_params[:name] )
    end
    render json: MerchantSerializer.new( merchant )
  end

  private

  def search_params
    params.permit(:id, :name, :created_at)
  end
end
