require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe "validation" do
    it "must have email address" do
      expect(user).to be_valid
    end

    it "is saved" do
      expect(described_class.count).to eq(0)
      expect { user.save! }.to change(described_class, :count).by(1)
    end
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
