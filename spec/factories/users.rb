FactoryBot.define do
  password = Faker::Internet.password
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  factory :user do
    first_name { first_name }
    last_name { last_name }
    password { password }
    password_confirmation { password }
    email_address { Faker::Internet.email(name: "#{first_name} #{last_name}") }
  end
end

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  confirmation_sent_at :datetime
#  confirmed_at         :datetime
#  email_address        :string           not null
#  first_name           :string           not null
#  last_name            :string           not null
#  password_digest      :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
