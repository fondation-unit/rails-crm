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
        redirect_to after_authentication_url, notice: "Vous êtes connecté"
      else
        redirect_to new_users_session_path,
                    notice: "Votre compte n'est pas validé."
      end
    else
      redirect_to new_users_session_path,
                  alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    flash[:notice] = "Vous avez été déconnecté"
    redirect_to new_users_session_path
  end
end
