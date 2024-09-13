require 'rails_helper'

RSpec.describe "Applicants", type: :system do
  context "as a user" do
    let(:user) { FactoryBot.create(:user) }
    let(:job) { 
      FactoryBot.create(:job,
        account: user.account,
        title: "Test job")
    }

    describe "creating an applicant" do
      it "is a success", js: true do
        sign_in user

        visit applicants_path

        expect {
          click_link "Add a new applicant" 

          fill_in "First name", with: "John"
          fill_in "Last name", with: "Doe"
          fill_in "Email", with: "johndoe@example.com"
          select "Test job", from: "applicant_job_id"
          select "Application", from: "applicant_stage"

          click_button "Submit"

          expect(page).to have_css("#applicants", text: "John Doe")
        }.to change(job.applicants, :count).by(1)
      end

      it "got errors", js: true do
        sign_in user

        visit applicants_path

        click_link "Add a new applicant"

        fill_in "First name", with: ""
        fill_in "Last name", with: ""
        fill_in "Email", with: ""

        click_button "Submit"

        expect(page).to have_content "Can't be blank"
      end
    end

    describe "visiting an applicant" do
      let!(:applicant) {
        FactoryBot.create(:applicant,
          job: job,
          first_name: "John",
          last_name: "Doe",
          email: "johndoe@example.com")
      }

      it "is a success", js: true do
        sign_in user

        visit applicants_path

        click_link "John Doe"

        expect(page).to have_current_path applicant_path(applicant)
        expect(page).to have_content "John Doe"
      end
    end

  end
end
