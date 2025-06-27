class UsersMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.users_mailer.account_confirmation.subject
  #
  def account_confirmation(user)
    @user = user
    mail to: user.email_address,
         subject: "Welcome to Confirmable! Please confirm your account."
  end
end
