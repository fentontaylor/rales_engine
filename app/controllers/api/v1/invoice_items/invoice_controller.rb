class Api::V1::InvoiceItems::InvoiceController < ApplicationController
  def show
    invoice_item = InvoiceItem.find_by_id(params[:id])
    render json: InvoiceSerializer.new(invoice_item.invoice)
  end
end
