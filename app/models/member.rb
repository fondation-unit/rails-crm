class Member < ApplicationRecord
  has_and_belongs_to_many :member_types, join_table: "member_types_members"

  has_one_attached :logo

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: false
  validates :zip_code, presence: false
  validates :city, presence: false
  validates :email_address,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }

  default_scope { includes([:member_types]) }
end

# == Schema Information
#
# Table name: members
#
#  id            :integer          not null, primary key
#  address       :string
#  city          :string
#  email_address :string
#  first_name    :string           not null
#  last_name     :string           not null
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
