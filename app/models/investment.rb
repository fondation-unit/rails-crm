class Investment < ApplicationRecord
  has_and_belongs_to_many :members, join_table: "members_investments"

  validates :name, presence: true

  scope :ordered, -> { order(name: "asc") }
end

# == Schema Information
#
# Table name: investments
#
#  id            :bigint           not null, primary key
#  email_address :string           not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
