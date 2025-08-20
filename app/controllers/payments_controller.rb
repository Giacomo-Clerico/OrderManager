class PaymentsController < ApplicationController
  before_action :set_order
  before_action :set_payment, only: [ :show ]
  before_action :authenticate_user!
  before_action :require_cashier_manager_or_director, only: [ :new, :create ]

  def index
    @payments = Payment.all
  end

  def new
    @payment = Payment.new
  end

  def create
    @payment = @order.payments.new(payment_params)
    @payment.paid_by = current_user
    if @payment.save
      redirect_to @order, notice: "Payment was successfully created."
    else
      render :new, notice: "Failed to create payment"
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:order_id, :company, :body, :bank, :account, :paid_by)
  end

  def require_cashier_manager_or_director
    unless %w[cashier manager director].include?(current_user.user_type)
      redirect_to root_path, alert: "You are not authorized to create quotes."
    end
  end
end
