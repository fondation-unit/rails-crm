class ApplicationController < ActionController::Base
  include Authentication
  include Pagy::Backend

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :verify_user_access, :resume_session

  helper_method :current_user

  private

  def verify_user_access
    return nil if Current.user.nil?

    if !Current.user.can_access_app?
      Current.user.send_confirmation_email
      terminate_session
      redirect_to new_users_session_path,
                  alert:
                    "You need to confirm your account before using the app."
    end
  end

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = Current.user
  end
end
