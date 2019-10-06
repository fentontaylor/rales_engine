class Api::V1::ItemsController < ApplicationController
  def index
    render json: ItemSerializer.new( Item.all )
  end

  def show
    render json: ItemSerializer.new( Item.find_by_id(params[:id]) )
  end
end
