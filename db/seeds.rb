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
  password: "STOPimb1524*",
  password_confirmation: "STOPimb1524*",
  confirmation_sent_at: Time.current,
  confirmed_at: Time.current
)
