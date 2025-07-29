class Organization < ApplicationRecord
  has_and_belongs_to_many :members, join_table: "members_organizations"

  has_one_attached :logo

  validates :name, presence: true

  scope :ordered, -> { order(name: "asc") }
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
