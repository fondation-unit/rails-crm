class Member < ApplicationRecord
  has_and_belongs_to_many :member_types, join_table: "member_types_members"
  has_and_belongs_to_many :organizations, join_table: "members_organizations"

  validates :first_name, :last_name, presence: true
  validates :gender,
            :position,
            :phone_number,
            :copil,
            :comex,
            :notes,
            presence: false
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
#  comex         :boolean
#  copil         :boolean
#  email_address :string           not null
#  first_name    :string           not null
#  gender        :string
#  last_name     :string           not null
#  notes         :text
#  phone_number  :string
#  position      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
