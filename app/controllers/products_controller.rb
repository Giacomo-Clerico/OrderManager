class ProductsController < ApplicationController
  before_action :set_product, only: [ :edit, :update, :destroy, :show ]
  before_action :authenticate_user!
  before_action :require_manager_or_director, except: [ :index ]

  def index
    @types = Product.distinct.pluck(:product_type)
    @categories = Product.distinct.pluck(:category) # new

    @products = Product.all

    if params[:query].present?
      q = "%#{params[:query]}%"
      @products = @products.joins(
        "LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_type = 'Product' AND action_text_rich_texts.record_id = products.id AND action_text_rich_texts.name = 'desctription'"
      ).where("products.code ILIKE :q OR action_text_rich_texts.body ILIKE :q", q: q)
    end

    if params[:type].present?
      @products = @products.where(product_type: params[:type])
    end

    if params[:category].present?
      @products = @products.where(category: params[:category])
    end

    @products = @products.order(:code).limit(50)
  end

  def show
  end
  def new
    @product = Product.new
    @categories = Product::CATEGORIES
  end

  ##
  # Creates a new Product from submitted parameters and, if specified, adds an initial Stock entry.
  # If the product saves and the provided initial stock quantity is greater than zero, creates a Stock record using the submitted storage id, storage type, quantity, and location, then redirects to the products list with a success notice. If saving fails, assigns category options and re-renders the new template.
  def create
    @product = Product.new(product_params)
    initial_quantity = initial_stock_params[:initial_stock_quantity].to_i
    initial_storage_id = initial_stock_params[:initial_storage_id]
    initial_location = initial_stock_params[:initial_location]
    initial_storage_type = initial_stock_params[:initial_storage_type]
    Rails.logger.debug "initial_quantity: #{initial_quantity.inspect}"
    Rails.logger.debug "initial_storage_id: #{initial_storage_id.inspect}"
    Rails.logger.debug "initial_storage_type: #{initial_storage_type.inspect}"
    if @product.save
      if initial_quantity > 0
        Stock.add!(
          product_id: @product.id,
          storage_id: initial_storage_id,
          storage_type: initial_storage_type,
          quantity: initial_quantity,
          location: initial_location
        )
      end
      redirect_to products_path, notice: "Product created successfully."
    else
      @categories = Product::CATEGORIES
      render :new
    end
  end


  ##
  # Prepares category options for the edit view.
  # Assigns Product::CATEGORIES to @categories for use by the edit template.
  def edit
    @categories = Product::CATEGORIES
  end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: "Product updated successfully."
    else
      @categories = Product::CATEGORIES
      render :edit
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: "Product deleted successfully."
  end

  def export_json
    products = Product.all.map do |product|
      {
        category: product.category,
        code: product.code,
        desctription: product.desctription.to_plain_text, # assuming rich text
        product_type: product.product_type
      }
    end

    send_data products.to_json,
      type: "application/json; header=present",
      disposition: "attachment",
      filename: "products_#{Time.now.strftime('%Y%m%d%H%M%S')}.json"
  end

  def import_json
    file = params[:file]
    if file.nil?
      redirect_to products_path, alert: "Please upload a JSON file."
      return
    end

    begin
      data = JSON.parse(file.read)

      data.each do |product_data|
        Product.create!(
          category: product_data["category"],
          code: product_data["code"],
          desctription: product_data["desctription"], # ActionText will handle it
          product_type: product_data["product_type"]
        )
      end

      redirect_to products_path, notice: "Product data imported successfully."
    rescue => e
      redirect_to products_path, alert: "Import failed: #{e.message}"
    end
  end


  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:category, :code, :desctription, :product_type)
  end

  ##
  # Restricts access to actions to users with user_type "manager" or "director".
  # If the current user is not a manager or director, redirects to `root_path` with the alert "You are not authorized to create, modify or delete products."
  def require_manager_or_director
    unless %w[manager director].include?(current_user.user_type)
      redirect_to root_path, alert: "You are not authorized to create, modify or delete products."
    end
  end

  ##
  # Permit and return initial stock-related parameters from the request.
  # @return [ActionController::Parameters] Parameters containing permitted keys: `:initial_stock_quantity`, `:initial_location`, `:initial_storage_id`, and `:initial_storage_type`.
  def initial_stock_params
    params.permit(:initial_stock_quantity, :initial_location, :initial_storage_id, :initial_storage_type)
  end
end