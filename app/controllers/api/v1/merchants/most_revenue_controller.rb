class Api::V1::Merchants::MostRevenueController < ApplicationController
  def index
    qty = params[:quantity].to_i
    merchants = Merchant.most_revenue(qty)
    render json: MerchantSerializer.new( merchants )
  end
end
