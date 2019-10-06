class Api::V1::Transactions::InvoiceController < ApplicationController
  def show
    transaction = Transaction.find_by_id(params[:id])
    render json: InvoiceSerializer.new(transaction.invoice)
  end
end
