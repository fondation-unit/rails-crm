class Member < ApplicationRecord
  include NameNormalization

  has_and_belongs_to_many :member_types, join_table: "member_types_members"
  has_and_belongs_to_many :organizations, join_table: "members_organizations"

  has_rich_text :notes

  validates :first_name, :last_name, presence: true
  validates :email_address,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }

  validates :phone_number, telephone_number: { country: "FR" }

  normalize_user_names :first_name, :last_name

  default_scope { includes([:member_types]) }

  def organizations_names
    organizations.collect { |org| { name: org.name, id: org.id } }
  end
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
