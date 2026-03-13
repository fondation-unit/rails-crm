require 'rails_helper'

RSpec.describe Member, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: members
#
#  id                 :integer          not null, primary key
#  comex              :boolean
#  copil              :boolean
#  decisionnaire      :boolean
#  email_address      :string           not null
#  first_name         :string           not null
#  gender             :string
#  last_name          :string           not null
#  linkedin           :string
#  linkedin_connected :boolean
#  phone_number       :string
#  position           :string
#  principal          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
