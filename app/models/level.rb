class Level < ApplicationRecord
  has_and_belongs_to_many :members, join_table: "members_levels"
  validates :name, presence: true

  scope :ordered, -> { order(name: "asc") }
end

# == Schema Information
#
# Table name: levels
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
