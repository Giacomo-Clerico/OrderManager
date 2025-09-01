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
    Stock.add!(
      product_id: params[:product_id],
      storage_id: params[:storage_id],
      storage_type: params[:storage_type],
      quantity: params[:quantity])
    redirect_to stocks_path, notice: "Stock updated!"
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
