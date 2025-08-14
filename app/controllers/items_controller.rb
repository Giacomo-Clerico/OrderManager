class ItemsController < ApplicationController
  before_action :set_order
  before_action :set_quote

  def new
    @item = @quote.items.new
  end

  def create
    @quote = Quote.find(params[:quote_id])
    @item = @quote.items.new(item_params)
    if @item.save
      redirect_back(fallback_location: order_path(@quote.order))
    else
      redirect_back(fallback_location: order_path(@quote.order), alert: "Item could not be added")
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_quote
    @quote = Quote.find(params[:quote_id])
  end

  def item_params
    params.require(:item).permit(:item_name, :price)
  end
end
