class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.








  allow_browser versions: { all: true } do
    true
  end



  before_action :authenticate_user!, unless: -> { request.path == new_user_session_path }
  before_action :load_announcement















  # Changes to the importmap will invalidate the etag for HTML responses







  stale_when_importmap_changes























  private




  def load_announcement
    path = Rails.root.join("public", "announcement.txt")
    if File.exist?(path)
      @announcement_raw = File.read(path).strip
      if @announcement_raw.present?
        renderer = Redcarpet::Render::HTML.new(filter_html: true, hard_wrap: true)
        markdown = Redcarpet::Markdown.new(renderer, extensions = {})
        @announcement_html = markdown.render(@announcement_raw).html_safe
      else
        @announcement_html = nil
      end
    else
      @announcement_html = nil
    end
  end










  def authenticate_user!
    unless current_user







      unless







      redirect_to new_user_session_path, alert: "Please log in first."







      end







    end
  end
end
