class Api::V1::InvoicesController < ApplicationController
  def index
    merchant = Merchant.find_by_id(params[:merchant_id])
    render json: InvoiceSerializer.new(merchant ? merchant.invoices : Invoice.all)
  end

  def show
    render json: InvoiceSerializer.new(Invoice.find(params[:id]))
  end
end
