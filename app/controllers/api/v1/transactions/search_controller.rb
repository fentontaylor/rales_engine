class Api::V1::Transactions::SearchController < ApplicationController
  def show
    transaction = Transaction.find_by( search_params )
    render json: TransactionSerializer.new( transaction )
  end

  def index
    transaction = Transaction.where( search_params ).order(:id)
    render json: TransactionSerializer.new( transaction )
  end

  private

  def search_params
    params.permit(
      :id,
      :invoice_id,
      :credit_card_number,
      :result,
      :created_at,
      :updated_at
    )
  end
end
