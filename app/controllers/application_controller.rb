class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :name ])
  end

  def safe_back_path(url)
    return nil if url.blank?

    begin
      uri = URI.parse(url)
    rescue URI::InvalidURIError
      return nil
    end

    return nil unless uri.host.nil? || uri.host == request.host
    uri.path.presence
  end
end
