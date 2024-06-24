require 'rails_helper'

RSpec.describe Comment, type: :model do
  context "validations" do
    it { should have_rich_text(:comment) }
  end

  context "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:commentable).counter_cache(:commentable_count).touch(:true) }
  end
end
