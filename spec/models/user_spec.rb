require 'rails_helper'

RSpec.describe User, type: :model do
  context "validations" do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }

    it "is valid with an account, email and password" do
      account = FactoryBot.create(:account)
      user = User.new(
        account: account,
        email: "tester@example.com",
        password: "password"
      )

      expect(user).to be_valid
    end

    it "is valid without a first name" do
      user = User.new(first_name: nil)

      user.valid?

      expect(user.errors[:first_name]).to_not include("can't be blank")
    end

    it "is valid without a last name" do
      user = User.new(last_name: nil)

      user.valid?

      expect(user.errors[:last_name]).to_not include("can't be blank")
    end
  end

  context "associations" do
    it { should belong_to(:account) }
    it { should belong_to(:invited_by).class_name("User").required(false) }
    it { should have_many(:emails).dependent(:destroy) }
    it { should have_many(:notifications).dependent(:destroy) }
    it { should have_many(:invited_users).class_name("User").with_foreign_key("invited_by_id").dependent(:nullify).inverse_of(:invited_by) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should accept_nested_attributes_for(:account) }
  end

  context "public methods" do
    describe "#name" do
      it "returns the full name of user" do
        user = User.new(
          first_name: "John",
          last_name: "Doe"
        )

        expect(user.name).to eq "John Doe"
      end

      it "returns 'Anonymous' when first name and last name are blank" do
        user = User.new(
          first_name: '',
          last_name: ''
        )

        expect(user.name).to eq "Anonymous"
      end
    end

    describe "#reset_invite!" do
      let(:inviting_user) { FactoryBot.create(:user) }
      let(:user) { FactoryBot.create(:user, account: inviting_user.account) }

      before do
        user.reset_invite!(inviting_user)
      end

      it "updates who invites to user" do
        expect(user.invited_by).to eq inviting_user
      end

      it "updates the invited_at timestamp" do
        expect(user.invited_at.to_date).to eq Date.current
      end
    end
  end

  context "private methods" do
    context "after create callback" do
      describe "#generate_alias" do
        it "updates email alias using email prefix and first 4 strings of user_id" do
          user = FactoryBot.create(:user, email: "tester@example.com")

          expect(user.email_alias).to eq "tester-#{user.id[0...4]}"
        end
      end
    end
  end
end
