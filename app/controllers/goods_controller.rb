class GoodsController < ApplicationController
  before_action :set_order
  before_action :set_delivery_note

  def new
    @good = @delivery_note.goods.new
  end

  def create
    @good = @delivery_note.goods.new(good_params)
    if @good.save
      redirect_back(fallback_location: order_path(@delivery_note))
    else
      redirect_back(fallback_location: order_path(@delivery_note), alert: "Good could not be added")
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_delivery_note
    @delivery_note = DeliveryNote.find(params[:delivery_note_id])
  end

  def good_params
    params.require(:good).permit(:description, :quantity, :location)
  end
end
