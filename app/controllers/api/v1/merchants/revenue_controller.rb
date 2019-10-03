class Api::V1::Merchants::RevenueController < ApplicationController
  def show
    date = params[:date]
    if valid_date?(date)
      output = RevenueSerializer.new(Merchant.revenue(date))
      render json: output.hash
    end
  end

  private

  def valid_date?(str)
    require 'date'
    parts = str.split('-')
    Date.valid_date? *parts.map(&:to_i)
  end
end
