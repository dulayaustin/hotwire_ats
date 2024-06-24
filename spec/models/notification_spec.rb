require 'rails_helper'

RSpec.describe Notification, type: :model do
  # context "validations" do
  #   it { should serialize(:params) }
  # end

  context "associations" do
    it { should belong_to(:user) }
  end

  context "scopes and class methods" do
    let!(:first_notification) { FactoryBot.create(:notification) }
    let!(:second_notification) { FactoryBot.create(:notification) }

    describe ".unread" do
      it "returns the notifications that has no read at value" do
        first_notification.read!

        expect(Notification.unread).to contain_exactly(second_notification)
      end
    end
  end

  context "public methods" do
    describe "#read!" do
      it "updates the notification read at timestamp" do
        notification = FactoryBot.create(:notification)

        notification.read!

        expect(notification.read_at.to_date).to eq Date.current
      end
    end
  end
end
