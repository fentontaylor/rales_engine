class Api::V1::CustomersController < ApplicationController
  def index
    render json: CustomerSerializer.new( Customer.all )
  end

  def show
    render json: CustomerSerializer.new( Customer.find_by_id(params[:id]) )
  end
end
