class PaymentsController < ApplicationController
  before_action :set_order
  before_action :set_quote
  before_action :set_payment, only: [ :show ]
  before_action :authenticate_user!
  before_action :require_cashier_manager_or_director, only: [ :new, :create ]

  def index
    @payments = @quote.payments.all
  end

  def new
    first_payment = @quote.payments.first
    if first_payment.present?
      @payment = @quote.payments.new(
        bank: first_payment.bank,
        account: first_payment.account,
        from_account: first_payment.from_account
      )
    else
      @payment = @quote.payments.new
    end
  end

  def create
    @payment = @quote.payments.new(payment_params)
    @payment.order = @order
    @payment.paid_by = current_user

    payment_currency = @quote.items.first&.currency

    @payment.currency = payment_currency if payment_currency.present?

    if @payment.amount > helpers.remaining_pay(@quote)
      redirect_to order_quote_path(@order, @quote), alert: "You cannot pay more than the remaining amount"
      return  # important: stop execution
    end

    @payment.company = @quote.company
    if @payment.save
      redirect_to order_quote_path(@order, @quote), notice: "Payment was successfully created."
    else
      render :new, notice: "Failed to create payment"
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end

  def set_quote
    @quote = @order.quotes.find(params[:quote_id])
  end

  def set_payment
    @payment = Payment.find(params[:id])
  end

  def payment_params
    params.require(:payment).permit(:order_id, :quote_id, :company, :body, :bank, :account, :paid_by, :from_account, :amount, :currency)
  end

  def require_cashier_manager_or_director
    unless %w[cashier manager director].include?(current_user.user_type)
      redirect_to root_path, alert: "You are not authorized to create quotes."
    end
  end
end
