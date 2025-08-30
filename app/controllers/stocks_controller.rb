class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @stocks = Stock.all
  end
  def show
    @stock = Stock.find(params[:id])
  end
  def new
    @stock = Stock.new
  end
  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      redirect_to stocks_path, notice: "Stock was successfully created."
    else
      render :new
    end
  end
  def add
    @stock = Stock.find_by(product_id: params[:product_id], storage_id: params[:storage_id], storage_type: params[:storage_type])

    product = Product.find_by(id: params[:product_id])
    unless product
      redirect_to stocks_path, alert: "Invalid product ID" and return
    end

    if @stock
      @stock.quantity += params[:quantity].to_i
    else
      @stock = Stock.new(product_id: params[:product_id], storage_id: params[:storage_id], storage_type: params[:storage_type], quantity: params[:quantity])
    end
    if @stock.save
      redirect_to stocks_path, notice: "Stock was successfully added."
    else
      Rails.logger.error @stock.errors.full_messages.to_sentence
      redirect_to stocks_path, alert: "Failed to add stock: #{@stock.errors.full_messages.to_sentence}"
    end
  end
  def edit
    @stock = Stock.find(params[:id])
  end
  def update
    @stock = Stock.find(params[:id])
    if @stock.update(stock_params)
      redirect_to stocks_path, notice: "Stock was successfully updated."
    else
      render :edit
    end
  end
  def destroy
    @stock = Stock.find(params[:id])
    @stock.destroy
    redirect_to stocks_path, notice: "Stock was successfully destroyed."
  end
  private
  def stock_params
    params.require(:stock).permit(:product_id, :storage_id, :storage_type, :quantity)
  end
end
