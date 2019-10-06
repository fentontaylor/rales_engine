class Api::V1::Invoices::SearchController < ApplicationController
  def show
    invoice = Invoice.find_by( search_params )
    render json: InvoiceSerializer.new( invoice )
  end

  def index
    invoice = Invoice.where( search_params ).order(id: :asc)
    render json: InvoiceSerializer.new( invoice )
  end

  private

  def search_params
    params.permit(
      :id,
      :customer_id,
      :merchant_id,
      :created_at,
      :updated_at )
  end
end
