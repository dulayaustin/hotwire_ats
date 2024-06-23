require 'rails_helper'

RSpec.describe Applicant, type: :model do
  context "validations" do
    it "has a valid factory" do
      expect(FactoryBot.build(:applicant)).to be_valid
    end

    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }

    it { should have_one_attached(:resume) }

    it do
      should define_enum_for(:stage)
        .with_values(
          application: 'application',
          interview: 'interview',
          offer: 'offer',
          hired: 'hired'
        ).backed_by_column_of_type(:string)
    end

    it do
      should define_enum_for(:status)
        .with_values(
          active: 'active',
          inactive: 'inactive'
        ).backed_by_column_of_type(:string)
    end
  end

  context "associations" do
    it { should belong_to(:job) }
    it { should have_many(:emails).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy).counter_cache(:commentable_count) }
  end

  context "scopes and class methods" do
    let(:job) { FactoryBot.create(:job) }
    let(:other_job) { FactoryBot.create(:job) }

    let!(:john_applicant) {
      FactoryBot.create(:applicant,
        job: job,
        first_name: "John",
        last_name: "Doe",
        email: "johndoe@example.com")
    }

    let!(:jane_applicant) {
      FactoryBot.create(:applicant,
        job: other_job,
        first_name: "Jane",
        last_name: "Doe",
        email: "janedoe@example.com")
    }

    let!(:elon_applicant) {
      FactoryBot.create(:applicant,
        job: job,
        first_name: "Elon",
        last_name: "Musk",
        email: "elonmusk@example.com")
    }

    describe ".for_account" do
      it "returns the applicants within account" do
        expect(Applicant.includes(:job).for_account(job.account)).to include(john_applicant, elon_applicant)
      end

      it "does not return any applicant when account is not present" do
        expect(Applicant.includes(:job).for_account(nil)).to be_blank
      end
    end

    describe ".for_job" do
      it "returns the applicants within job" do
        expect(Applicant.for_job(other_job)).to include(jane_applicant)
      end

      it "returns all applicants when job value is not present" do
        expect(Applicant.for_job(nil)).to include(john_applicant, jane_applicant, elon_applicant)
      end
    end

    describe ".search" do
      it "returns the applicants by searching a keyword on first name" do
        expect(Applicant.search("Jane")).to include(jane_applicant)
      end

      it "returns the applicants by searching a keyword on last name" do
        expect(Applicant.search("doe")).to include(john_applicant, jane_applicant)
      end

      it "returns the applicants by searching a keyword on email" do
        expect(Applicant.search("elon")).to include(elon_applicant)
      end

      it "returns all applicants when keyword is not present" do
        expect(Applicant.search(nil)).to include(john_applicant, jane_applicant, elon_applicant)
      end

      it "does not return any applicant when theres no prefix keyword searched on first name, last name and email" do
        expect(Applicant.search("example")).to be_blank
      end
    end

    describe ".sorted" do
      it "returns the applicants by created at ascending order" do
        expect(Applicant.sorted("created_at-asc")).to eq [john_applicant, jane_applicant, elon_applicant]
      end

      it "returns the applicants by created at descending order" do
        expect(Applicant.sorted("created_at-desc")).to eq [elon_applicant, jane_applicant, john_applicant]
      end

      it "returns the applicants by created at ascending order when sort value is not present" do
        expect(Applicant.sorted(nil)).to eq [john_applicant, jane_applicant, elon_applicant]
      end
    end

    describe ".apply_sort" do
      it "returns the applicants by created at ascending order" do
        expect(Applicant.apply_sort("created_at-asc")).to eq [john_applicant, jane_applicant, elon_applicant]
      end

      it "returns the applicants by created at descending order" do
        expect(Applicant.apply_sort("created_at-desc")).to eq [elon_applicant, jane_applicant, john_applicant]
      end

      it "does not return any applicant when sort value is not present" do
        expect(Applicant.apply_sort(nil)).to be_blank
      end
    end

    describe ".filter" do
      it "returns the applicants by filtered values" do
        filter_params = {
          "sort" => "created_at-desc",
          "job" => job.id,
          "query" => "Doe"
        }

        expect(Applicant.filter(filter_params)).to eq [john_applicant]
      end
    end
  end

  context "public methods" do
    describe "#name" do
      it "returns the full name of applicant" do
        applicant = Applicant.new(
          first_name: "John",
          last_name: "Doe"
        )

        expect(applicant.name).to eq "John Doe"
      end
    end
  end
end
