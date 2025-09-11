class RequestsController < ApplicationController
  before_action :set_order
  before_action :set_request, only: [ :destroy ]

  def new
    @request = @order.requests.new
  end

  def create
    @request = @order.requests.new(request_params)
    if @request.save
      redirect_to @order, notice: "Request added successfully."
    else
      redirect_to @order, alert: "Failed to add request: #{@request.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    @request.destroy
    redirect_to @order, notice: "Request deleted successfully."
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_request
    @request = @order.requests.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:product_id, :quantity)
  end
end
