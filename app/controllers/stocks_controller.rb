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

  def export_json
    stocks = Stock.all.map do |stock|
      {
        product_code: stock.product&.code,
        storage: stock.storage&.abbreviation,
        location: stock.location,
        quantity: stock.quantity
      }
    end

    send_data stocks.to_json,
      type: "application/json; header=present",
      disposition: "attachment",
      filename: "stocks_#{Time.now.strftime('%Y%m%d%H%M%S')}.json"
  end

  def import_json
    file = params[:file]
    if file.nil?
      redirect_to stocks_path, alert: "Please upload a JSON file."
      return
    end

    begin
      data = JSON.parse(file.read)

      data.each do |stock_data|
        product = Product.find_by(code: stock_data["product_code"])
        storage = Storage.find_by(abbreviation: stock_data["storage"])
        next unless product && storage

        Stock.create!(
          product_id: product.id,
          storage_id: storage.id,
          storage_type: storage.class.name,
          location: stock_data["location"],
          quantity: stock_data["quantity"]
        )
      end

      redirect_to stocks_path, notice: "Stock data imported successfully."
    rescue => e
      redirect_to stocks_path, alert: "Import failed: #{e.message}"
    end
  end

  private
  def stock_params
    params.require(:stock).permit(:product_id, :storage_id, :storage_type, :quantity)
  end
end
