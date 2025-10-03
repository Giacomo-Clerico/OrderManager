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

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: "Product created successfully."
    else
      render :new
    end
  end

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

  private
  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:category, :code, :desctription, :product_type)
  end

  def require_manager_or_director
    unless %w[manager director].include?(current_user.user_type)
      redirect_to root_path, alert: "You are not authorized to create, modify or delete products."
    end
  end
end
