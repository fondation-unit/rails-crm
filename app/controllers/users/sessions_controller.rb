class Users::SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  layout "authentication"

  rate_limit to: 10,
             within: 3.minutes,
             only: :create,
             with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(params.permit(:email_address, :password))
      if user.confirmed?
        start_new_session_for user
        redirect_to after_authentication_url,
                    notice: I18n.t("Your're connected")
      else
        redirect_to new_users_session_path,
                    notice: I18n.t("Your account is not validated")
      end
    else
      redirect_to new_users_session_path,
                  alert: I18n.t("Try another email address or password.")
    end
  end

  def destroy
    terminate_session
    flash[:notice] = I18n.t("You're disconnected")
    redirect_to new_users_session_path
  end
end
