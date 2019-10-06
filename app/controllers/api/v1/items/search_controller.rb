class Api::V1::Items::SearchController < ApplicationController
  def show
    item = Item.search( search_params )
    render json: ItemSerializer.new( item )
  end

  def index
    item = Item.search( search_params, multiple: true )
    render json: ItemSerializer.new( item )
  end

  private

  def search_params
    params.permit(
      :id,
      :name,
      :description,
      :unit_price,
      :merchant_id,
      :created_at,
      :updated_at
    )
  end
end
