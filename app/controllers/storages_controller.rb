class StoragesController < ApplicationController
  before_action :set_storage, only: [ :edit, :update, :destroy, :show ]
  before_action :authenticate_user!
  before_action :require_manager_or_director, except: [ :index, :show ]

  def index
    @storages = Storage.all
  end
  def show
  end
  def new
    @storage = Storage.new
  end
  def create
    @storage = Storage.new(storage_params)
    if @storage.save
      redirect_to storages_path, notice: "Storage created successfully."
    else
      render :new
    end
  end
  def destroy
    @storage.destroy
    redirect_to storages_path, notice: "Storage deleted successfully."
  end


  private
  def set_storage
    @storage = Storage.find(params[:id])
  end

  def storage_params
    params.require(:storage).permit(:name, :abbreviation)
  end

  def require_manager_or_director
    unless %w[manager director].include?(current_user.user_type)
      redirect_to root_path, alert: "You are not authorized to create, modify or delete products."
    end
  end
end
