class Organization < ApplicationRecord
  has_and_belongs_to_many :members, join_table: "members_organizations"

  has_one_attached :logo

  validates :name, presence: true
  validates :address, presence: false
  validates :zip_code, presence: false
  validates :city, presence: false
  validates :lat, presence: false
  validates :lng, presence: false
end

# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  address    :string
#  city       :string
#  lat        :float
#  lng        :float
#  name       :string           not null
#  zip_code   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
