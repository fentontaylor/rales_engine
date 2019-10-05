class Api::V1::Items::BestDayController < ApplicationController
  def show
    item = Item.find_by_id(params[:id])
    render json: BestDaySerializer.new(item.best_day).json
  end
end
