module Crm
  class Discipline < ApplicationRecord
    has_and_belongs_to_many :members, join_table: "members_disciplines"
    validates :name, presence: true

    scope :ordered, -> { order(name: "asc") }
  end
end

# == Schema Information
#
# Table name: disciplines
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
