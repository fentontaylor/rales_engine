class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = case search_params.keys.first
    when 'id'
      Merchant.find_by( search_params )
    when 'name'
      Merchant.find_by_lower_name( search_params[:name], all: false )
    when 'created_at'
      Merchant.find_by_flex_date(created_at: search_params[:created_at])
    when 'updated_at'
      Merchant.find_by_flex_date(updated_at: search_params[:updated_at])
    end
    render json: MerchantSerializer.new( merchant )
  end

  def index
    merchant = case search_params.keys.first
    when 'id'
      Merchant.all_by_id( search_params[:id] )
    when 'name'
    when 'created_at'
    when 'updated_at'
    end
    render json: MerchantSerializer.new( merchant )
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
