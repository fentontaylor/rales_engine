class Api::V1::ItemsController < ApplicationController
  def index
    merchant = Merchant.find_by_id( params[:merchant_id] )
    render json: ItemSerializer.new( merchant ? merchant.items : Item.all )
  end

  def show
    render json: ItemSerializer.new( Item.find(params[:id]) )
  end
end
