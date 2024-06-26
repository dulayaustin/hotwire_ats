require 'rails_helper'

RSpec.describe "Jobs", type: :system do
  context "as a user" do
    let(:user) { FactoryBot.create(:user) }

    describe "creating a job" do
      it "is a success", js: true do
        sign_in user

        visit jobs_path

        expect {
          click_link "Post a new job"

          fill_in "Title", with: "Test job"
          find('#job_description').click.set('For testing purposes only')
          select "Open", from: "job_status"
          select "Full time", from: "job_job_type"
          fill_in "Location", with: "USA"

          click_button "Submit"

          expect(page).to have_css("#jobs", text: "Test job")
        }.to change(user.account.jobs, :count).by(1)
      end

      it "got errors", js: true do
        sign_in user

        visit jobs_path

        click_link "Post a new job"

        fill_in "Title", with: ""
        fill_in "Location", with: ""

        click_button "Submit"

        expect(page).to have_content "Can't be blank"
      end
    end

    describe "editing a job" do
      let!(:job) {
        FactoryBot.create(:job,
          account: user.account,
          title: "Test job")
      }

      it "is a success", js: true do
        sign_in user

        visit jobs_path

        click_link "Test job"

        fill_in "Title", with: "Edited test job"
        find('#job_description').click.set('For testing purposes only')
        select "Draft", from: "job_status"
        select "Part time", from: "job_job_type"
        fill_in "Location", with: "USA"

        click_button "Submit"

        expect(page).to have_css("#jobs", text: "Edited test job")
      end

      it "got errors", js: true do
        sign_in user

        visit jobs_path

        click_link "Test job"

        fill_in "Title", with: ""
        fill_in "Location", with: ""

        click_button "Submit"

        expect(page).to have_content "Can't be blank"
      end
    end

    describe "deleting a job" do
      let!(:job) {
        FactoryBot.create(:job,
          account: user.account,
          title: "Test job")
      }

      it "is a success", js: true do
        sign_in user

        visit jobs_path

        expect {
          find("#job_#{job.id}").click_button "Delete job"
          accept_alert

          expect(page).to_not have_css("#jobs", text: "Test job")
        }.to change(user.account.jobs, :count).by(-1)
      end
    end
  end

  context "as a guest" do
    describe "visiting jobs page" do
      it "is not accessible" do
        visit jobs_path

        aggregate_failures do
          expect(page).to have_current_path "/login"
          expect(page).to have_css("#flash-container", text: "You need to sign in or sign up before continuing.")
        end
      end
    end
  end
end
