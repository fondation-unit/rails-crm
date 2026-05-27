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
#  id                    :bigint           not null, primary key
#  comex                 :boolean
#  copil                 :boolean
#  decisionnaire         :boolean
#  email_address         :string           not null
#  first_name            :string           not null
#  gender                :string
#  last_name             :string           not null
#  linkedin              :string
#  linkedin_connected    :boolean
#  newsletter_ressources :boolean
#  phone_number          :string
#  position              :string
#  principal             :boolean
#  search_vector         :tsvector
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_members_on_email_address  (email_address) UNIQUE
#  index_members_on_search_vector  (search_vector) USING gin
#
