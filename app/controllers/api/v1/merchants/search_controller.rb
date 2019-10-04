class Api::V1::Merchants::SearchController < ApplicationController
  def show
    merchant = case search_params.keys.first
    when 'id'
      Merchant.find_by( search_params )
    when 'name'
      Merchant.find_by_lower_name( search_params[:name], all: false )
    when 'created_at', 'updated_at'
      # Merchant.find_by_flex_date(created_at: search_params[:created_at])
      Merchant.where( search_params ).first
    # when 'updated_at'
    #   # Merchant.find_by_flex_date(updated_at: search_params[:updated_at])
    #   Merchant.where( search_params ).first

    end
    render json: MerchantSerializer.new( merchant )
  end

  def index
    merchant = case search_params.keys.first
    when 'id'
      Merchant.where( search_params )
    when 'name'
      Merchant.find_by_lower_name( search_params[:name] )
    when 'created_at', 'updated_at'
      # Merchant.find_by_flex_date(created_at: search_params[:created_at])
      Merchant.where( search_params )

    # when 'updated_at'
    #   # Merchant.find_by_flex_date(updated_at: search_params[:updated_at])
    #   Merchant.where( search_params )

    end
    render json: MerchantSerializer.new( merchant )
  end

  private

  def search_params
    params.permit(:id, :name, :created_at, :updated_at)
  end
end
