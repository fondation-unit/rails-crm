class ApplicationController < ActionController::Base
  include Authentication
  before_action :resume_session
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def verify_user_access
    return nil if Current.user.nil?

    if !Current.user.can_access_app?
      terminate_session
      redirect_to new_users_session_path,
                  alert:
                    "You need to confirm your account before using the app."
    end
  end
end
