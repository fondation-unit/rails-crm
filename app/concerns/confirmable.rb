module Confirmable
  extend ActiveSupport::Concern

  ACCESS_BEFORE_CONFIRMATION_IN_HOURS = 2.hours

  included do
    generates_token_for :user_confirmation,
                        expires_in: ACCESS_BEFORE_CONFIRMATION_IN_HOURS
  end

  def confirm!
    return true if confirmed?
    update!(confirmed_at: Time.current)
  end

  def can_access_app?
    confirmed? || (Time.current < confirmation_deadline)
  end

  def confirmed?
    confirmed_at.present?
  end

  def confirmation_deadline
    confirmation_sent_at + ACCESS_BEFORE_CONFIRMATION_IN_HOURS
  end

  def expiring_token
    generate_token_for(:user_confirmation)
  end

  def send_confirmation_email
    transaction do
      UsersMailer.account_confirmation(self).deliver_now
      update!(confirmation_sent_at: Time.current)
    end
  end
end
