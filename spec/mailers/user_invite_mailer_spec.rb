require "rails_helper"

RSpec.describe UserInviteMailer, type: :mailer do
  describe "#invite" do
    let(:user) { FactoryBot.create(:user) }
    let(:inviting_user) { FactoryBot.create(:user) }

    before do
      user.reset_invite!(inviting_user)
      @mail = described_class.invite(user)
    end

    context "headers" do
      it "sends to the right email" do
        expect(@mail.to).to eq [user.email]
      end

      it "sends from default email" do
        expect(@mail.from).to eq ["do-not-reply@hotwire-ats-app.onrender.com"]
      end

      it "sends with email's subject" do
        expect(@mail.subject).to eq "#{inviting_user.name} wants you to join Hotwired ATS"
      end
    end

    context "body contents" do
      it "greets the user by first name" do
        expect(@mail.body.encoded).to match(/Hi #{user.first_name},/)
      end

      it "tells the user whose invited them" do
        expect(@mail.body.encoded).to match inviting_user.name
      end

      it "includes accept invite url with the user's token" do
        expect(@mail.body.encoded).to include accept_invite_url(token: user.invite_token)
      end
    end
  end
end
