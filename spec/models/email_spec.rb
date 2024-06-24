require 'rails_helper'

RSpec.describe Email, type: :model do
  context "validations" do
    it "has a valid factory" do
      expect(FactoryBot.build(:email)).to be_valid
    end

    it { should validate_presence_of(:subject) }

    it { should have_rich_text(:body) }

    it do
      should define_enum_for(:email_type)
        .with_values(
          outbound: 'outbound',
          inbound: 'inbound')
        .backed_by_column_of_type(:string)
    end
  end

  context "associations" do
    it { should belong_to(:applicant) }
    it { should belong_to(:user) }
  end
end
