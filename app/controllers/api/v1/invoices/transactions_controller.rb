class Api::V1::Invoices::TransactionsController < ApplicationController
  def index
    invoice = Invoice.find_by_id(params[:invoice_id])
    render json: TransactionSerializer.new(invoice.transactions)
  end
end
