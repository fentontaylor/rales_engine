class Api::V1::InvoicesController < ApplicationController
  def index
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      render json: InvoiceSerializer.new(merchant.invoices)
    end
  end
end
