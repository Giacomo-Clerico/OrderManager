class OrdersController < ApplicationController
  def index
    @order = Order.order(:id)
  end
  def show
    @order = Order.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "Order not found"
  end

  def new
    @order = Order.new
  end

  def create
    @order = current_user.orders.build(order_params)
    if @order.save
      redirect_to @order
    else
      render :new, status: :unprocessable_entity
    end
  end

  def check
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director" ])
      redirect_to root_path, alert: "You are not authorized for technical approvals"
      return  # important: stop execution
    end

    if @order.update_columns(checked_by_id: current_user.id, checked_at: Time.current, checked: true)
      redirect_to @order, notice: "Order checked successfully"
    else
      redirect_to @order, alert: "Unable to check order"
    end
  end

  def refuse
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director" ])
      redirect_to @order, alert: "You are not authorized for technical approvals"
      return  # important: stop execution
    end

    if @order.update_columns(checked_by_id: current_user.id, checked_at: Time.current, checked: false)
      redirect_to @order, notice: "Order refused successfully"
    else
      redirect_to @order, alert: "Unable to refuse order"
    end
  end

  def submit_quote
    @order = Order.find(params[:id])
    unless current_user.user_type.in?([ "manager", "director", "procurement" ])
      redirect_to @order, alert: "You are not authorized for submitting quotes"
      return  # important: stop execution
    end

    if @order.checked_by.nil?
      redirect_to @order, alert: "The order must be checked before submitting quotes"
      return  # important: stop execution
    end

    if @order.quotes.empty?
      redirect_to @order, alert: "No quotes available to submit"
      return # important: stop execution
    end

    unless @order.quotes_submitted_by.nil?
      redirect_to @order, alert: "Quotes already submitted for this order"
      return  # important: stop execution
    end

    if @order.update_columns(quotes_submitted_at: Time.current, quotes_submitted_by_id: current_user.id)
      redirect_to @order, notice: "Quotes submitted successfully"
    else
      redirect_to @order, alert: "Unable to submit quotes"
    end
  end

  private

    def order_params
      params.require(:order).permit(:name, :description)
    end
end
