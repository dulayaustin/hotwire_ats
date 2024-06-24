require "rails_helper"

RSpec.describe ApplicantMailer, type: :mailer do
  describe "#contact" do
    let(:email) {
      FactoryBot.create(:email,
        subject: "Test subject",
        body: "Test body")
    }
    let(:mail) { described_class.contact(email: email) }

    context "headers" do
      it "sends a contact mail to applicant" do
        expect(mail.to).to eq [email.applicant.email]
      end

      it "sends from user email alias" do
        expect(mail.from).to eq ["reply-#{email.user.email_alias}@hotwiringrails.com"]
      end

      it "sends with email's subject" do
        expect(mail.subject).to eq "Test subject"
      end
    end

    context "body contents" do
      it "is compose of email's body" do
        expect(mail.body.encoded).to match "Test body"
      end
    end
  end
end
