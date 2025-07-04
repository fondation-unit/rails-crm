FactoryBot.define do
  factory :member do
    name { "MyString" }
    address { "MyString" }
    zip_code { "MyString" }
    city { "MyString" }
    logo { nil }
  end
end

# == Schema Information
#
# Table name: members
#
#  id         :integer          not null, primary key
#  address    :string
#  city       :string
#  name       :string
#  zip_code   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
