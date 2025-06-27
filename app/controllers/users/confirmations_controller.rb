class Users::ConfirmationsController < ApplicationController
  skip_before_action :require_authentication

  layout "authentication"

  def create
    Current.user.send_confirmation_email
    redirect_to root_path, notice: "Confirmation email resent"
  end

  def show
    user = User.find_by_token_for(:user_confirmation, params[:token])
    if user.present? && user.confirm!
      redirect_to root_path,
                  notice: "Votre compte e a bien été validé, bienvenue !"
    else
      redirect_to root_path, alert: "Le lien est invalide ou a expiré."
    end
  end
end
