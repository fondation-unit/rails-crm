# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
#
Faker::Config.locale = "fr"
User.create!(
  first_name: "User",
  last_name: "Dummy",
  email_address: "dummy@example.com",
  password: ENV["DUMMY_USER_PASSWORD"],
  password_confirmation: ENV["DUMMY_USER_PASSWORD"],
  confirmation_sent_at: Time.current,
  confirmed_at: Time.current
)

%i[Partenaire Consortium Divers].each { |name| MemberType.create!(name: name) }

5.times do |o|
  Organization.create!(
    name: Faker::Company.name,
    address: Faker::Address.full_address,
    zip_code: Faker::Address.zip_code,
    city: Faker::Address.city,
    lat: Faker::Address.latitude,
    lng: Faker::Address.longitude
  )
end

10.times do |i|
  member =
    Member.create!(
      gender: Faker::Gender.type,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      position: Faker::Job.position,
      phone_number: Faker::PhoneNumber.phone_number_with_country_code,
      email_address: "dummy#{i}@example.com",
      copil: Faker::Boolean,
      comex: Faker::Boolean,
      notes: Faker::Lorem.paragraph
    )

  member.member_types << MemberType.all.to_a.sample(rand(1..3))
  member.organizations << Organization.all.to_a.sample(rand(1..2))
end
