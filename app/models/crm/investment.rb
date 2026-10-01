module Crm
  class Investment < ApplicationRecord
    has_and_belongs_to_many :members, join_table: "crm_members_investments"

    validates :name, presence: true

    scope :ordered, -> { order(name: "asc") }
  end
end

# == Schema Information
#
# Table name: investments
#
#  id         :bigint           not null, primary key
#  copy       :string           not null
#  name       :string           not null
#  referent1  :string           not null
#  referent2  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
