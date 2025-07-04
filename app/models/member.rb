class Member < ApplicationRecord
  has_one_attached :logo
  has_and_belongs_to_many :member_types, join_table: "member_types_members"
  validates :name, presence: true
  validates :address, presence: true
  validates :zip_code, presence: true
  validates :city, presence: true
  #validates_associated :member_types, presence: true
  #
  default_scope { includes([:member_types]) }
end

# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  address    :string
#  city       :string
#  name       :string
#  zip_code   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
