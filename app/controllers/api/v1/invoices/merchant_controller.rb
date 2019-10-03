class Api::V1::Invoices::MerchantController < ApplicationController
  def index
    invoice = Invoice.find_by_id(params[:invoice_id])
    render json: MerchantSerializer.new(invoice.merchant)
  end
end
