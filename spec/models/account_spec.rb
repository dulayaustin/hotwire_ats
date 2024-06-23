require 'rails_helper'

RSpec.describe Account, type: :model do
  context "validations" do
    it { should validate_presence_of(:name) }
  end

  context "associations" do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:jobs).dependent(:destroy) }
    it { should have_many(:applicants).through(:jobs) }
  end
end
