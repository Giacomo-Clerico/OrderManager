class ItemsController < ApplicationController
  before_action :set_order
  before_action :set_quote

  def new
    @item = @quote.items.new
  end

  def create
    @quote = Quote.find(params[:quote_id])
    @item = @quote.items.new(item_params.merge(selected: false, recommended: false))
    unless @quote.order.quotes_submitted_by_id.nil?
      unless current_user.user_type.in?([ "manager", "director" ])
        redirect_to @quote.order, alert: "You are not authorized to add items to this already submitted quote"
        return  # important: stop execution
      end
    end
    if @item.save
      redirect_back(fallback_location: order_path(@quote.order))
    else
      redirect_back(fallback_location: order_path(@quote.order), alert: "Item could not be added")
    end
  end



  def select
    @item = @quote.items.find(params[:id])

    # Only allow managers and directors to select items
    unless current_user.user_type.in?([ "manager", "director" ])
      redirect_to @order, alert: "You are not authorized for selecting items"
      return  # important: stop execution
    end

    if @item.update_columns(selected: true)
      redirect_to @order
    else
      redirect_to @order, alert: "Unable to select item"
    end
  end


  def unselect
    @item = @quote.items.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director" ])
      redirect_to @order, alert: "You are not authorized for selecting items"
      return  # important: stop execution
    end

    if @item.update_columns(selected: false)
      redirect_to @order
    else
      redirect_to @order, alert: "Unable to unselect item"
    end
  end



  def recommend
    @item = @quote.items.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director", "procurement" ])
      redirect_to @order, alert: "You are not authorized for recommending items"
      return  # important: stop execution
    end

    # Check if the quote has already been submitted
    unless @order.quotes_submitted_by_id.nil?
      unless current_user.user_type.in?([ "manager", "director" ])
        redirect_to @order, alert: "the quote has already been submitted, you cannot recommend items"
        return  # important: stop execution
      end
    end

    if @item.update_columns(recommended: true)
      redirect_to @order
    else
      redirect_to @order, alert: "Unable to recommend item"
    end
  end


  def unrecommend
    @item = @quote.items.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director", "procutement" ])
      redirect_to @order, alert: "You are not authorized for unrecommending items"
      return  # important: stop execution
    end

    unless @order.quotes_submitted_by_id.nil?
      unless current_user.user_type.in?([ "manager", "director" ])
        redirect_to @order, alert: "the quote has already been submitted, you cannot unrecommend items"
        return  # important: stop execution
      end
    end

    if @item.update_columns(recommended: false)
      redirect_to @order
    else
      redirect_to @order, alert: "Unable to unrecommend item"
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
    params.require(:item).permit(:item_name, :price, :currency)
  end
end
