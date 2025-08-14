class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_manager

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # Generate a random password or use a default one, or require password in form
    # generated_password = Devise.friendly_token.first(8)
    @user.password = "password"
    @user.password_confirmation = "password"

    if @user.save
      redirect_to users_path, notice: "User created successfully. Temporary password: password"
    else
      flash.now[:alert] = "Error creating user."
      render :new
    end
  end

  private

  def require_manager
    unless current_user.user_type == "manager" || current_user.user_type == "director"
      redirect_to root_path, alert: "You are not authorized to manage users."
    end
  end

  def user_params
    params.require(:user).permit(:email, :user_type)
  end
end
