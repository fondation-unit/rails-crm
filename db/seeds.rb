# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
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

10.times do |i|
  member =
    Member.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email_address: "dummy#{i}@example.com"
    )

  member.member_types << MemberType.all.to_a.sample(rand(1..3))
end
