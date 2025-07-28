class Member < ApplicationRecord
  include NameNormalization

  has_and_belongs_to_many :member_types, join_table: "member_types_members"
  has_and_belongs_to_many :organizations, join_table: "members_organizations"

  validates :first_name, :last_name, presence: true
  validates :email_address,
            uniqueness: true,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }

  validates :phone_number,
            telephone_number: {
              country: "FR",
              message: "Numéro de téléphone invalide"
            }

  normalize_user_names :first_name, :last_name

  before_save :set_phone_number

  default_scope { includes([:member_types]) }

  def organizations_names
    organizations.collect { |org| { name: org.name, id: org.id } }
  end

  def set_phone_link
    phone_object = TelephoneNumber.parse(phone_number, :fr)
    self.phone_number = phone_object.e164_number
  end

  private

  def set_phone_number
    phone_object = TelephoneNumber.parse(phone_number, :fr)
    self.phone_number = phone_object.international_number
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
#  phone_number  :string
#  position      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
