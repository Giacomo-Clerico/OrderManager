class QuotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order
  before_action :require_procurement_manager_or_director, only: [ :new, :create ]

  def new
    @quote = @order.quotes.new
    @quote.order_id = params[:order_id] if params[:order_id].present?
  end

  def create
    @quote = @order.quotes.new(quote_params)
    @quote.requested_by = current_user
    if @quote.save
      redirect_to [ @order, @quote ], notice: "Quote created successfully"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
    @quote = @order.quotes.find(params[:id])
    @items = @quote.items
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def quote_params
    params.require(:quote).permit(:order_id, :company, :company_address, :body)
  end

  def require_procurement_manager_or_director
    unless %w[procurement manager director].include?(current_user.user_type)
      redirect_to root_path, alert: "You are not authorized to create quotes."
    end
  end
end
