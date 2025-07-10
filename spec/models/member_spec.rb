require 'rails_helper'

RSpec.describe Member, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: members
#
#  id            :integer          not null, primary key
#  address       :string
#  city          :string
#  email_address :string
#  first_name    :string           not null
#  last_name     :string           not null
#  zip_code      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
