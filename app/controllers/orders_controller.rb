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
    if @order.update_columns(checked_by_id: current_user.id, checked_at: Time.current)
      redirect_to @order, notice: "Order checked successfully"
    else
      redirect_to @order, alert: "Unable to check order"
    end
  end

  private
    def order_params
      params.require(:order).permit(:name, :description)
    end
end
