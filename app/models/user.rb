class User < ApplicationRecord
  include Confirmable
  ACCESS_BEFORE_CONFIRMATION_IN_HOURS = 1.hour

  has_secure_password
  has_many :sessions, dependent: :destroy
  generates_token_for :user_confirmation,
                      expires_in: ACCESS_BEFORE_CONFIRMATION_IN_HOURS

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email_address,
            presence: true,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }
  validates :password_digest, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  confirmation_sent_at :datetime
#  confirmed_at         :datetime
#  email_address        :string           not null
#  first_name           :string           not null
#  last_name            :string           not null
#  password_digest      :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
