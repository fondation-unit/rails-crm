class MemberType < ApplicationRecord
  has_and_belongs_to_many :members, join_table: "member_types_members"
  validates :name, presence: true
end

# == Schema Information
#
# Table name: member_types
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
