class MemberType < ApplicationRecord
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
