require "rails_helper"

RSpec.describe UsersMailer, type: :mailer do
  describe "account_confirmation" do
    let(:user) { create(:user) }
    let(:token) { user.expiring_token }
    let(:mail) { described_class.account_confirmation(user) }

    before { allow(user).to receive(:expiring_token).and_return(token) }

    it "renders the headers" do
      expect(mail.subject).to eq(
        "Welcome to Confirmable! Please confirm your account."
      )
      expect(mail.to).to eq([user.email_address])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body with confirmation link and user email" do
      html_body = mail.html_part.body.decoded

      expect(html_body).to include(users_confirmations_url(token: token))
    end
  end
end
