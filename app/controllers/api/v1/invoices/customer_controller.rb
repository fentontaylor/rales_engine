class Api::V1::Invoices::CustomerController < ApplicationController
  def show
    invoice = Invoice.find_by_id(params[:invoice_id])
    render json: CustomerSerializer.new(invoice.customer)
  end
end
