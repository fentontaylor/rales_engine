class Api::V1::InvoicesController < ApplicationController
  def index
    render json: InvoiceSerializer.new( Invoice.all )
  end

  def show
    render json: InvoiceSerializer.new(Invoice.find_by_id(params[:id]))
  end
end
