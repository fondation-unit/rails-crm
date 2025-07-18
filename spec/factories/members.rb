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
#  id            :integer          not null, primary key
#  comex         :boolean
#  copil         :boolean
#  email_address :string           not null
#  first_name    :string           not null
#  gender        :string
#  last_name     :string           not null
#  notes         :text
#  phone_number  :string
#  position      :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
