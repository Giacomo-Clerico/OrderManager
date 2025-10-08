class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.



  allow_browser versions: { all: true } do
    true
  end

  before_action :authenticate_user!, unless: -> { request.path == new_user_session_path }







  # Changes to the importmap will invalidate the etag for HTML responses



  stale_when_importmap_changes











  private







  def authenticate_user!
    unless current_user



      unless



      redirect_to new_user_session_path, alert: "Please log in first."



      end



    end
  end
end
