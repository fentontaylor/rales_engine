class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = case search_params.keys.first
    when 'id'
      Merchant.find_by( search_params )
    when 'name'
      Merchant.find_by_lower_name( search_params[:name] )
    when 'created_at'
      Merchant.find_by_flex_date(created_at: search_params[:created_at])
    end
    render json: MerchantSerializer.new( merchant )
  end

  private

  def search_params
    params.permit(:id, :name, :created_at)
  end
end
