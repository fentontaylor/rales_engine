class Api::V1::Invoices::InvoiceItemsController < ApplicationController
  def index
    invoice = Invoice.find_by_id(params[:invoice_id])
    render json: InvoiceItemSerializer.new(invoice.invoice_items)
  end
end
