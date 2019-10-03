class Api::V1::Invoices::ItemsController < ApplicationController
  def index
    invoice = Invoice.find_by_id(params[:invoice_id])
    render json: ItemSerializer.new(invoice.items)
  end
end
