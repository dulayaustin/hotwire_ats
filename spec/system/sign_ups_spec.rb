require 'rails_helper'

RSpec.describe "Sign Ups", type: :system do
  context "as a user" do
    it "successfully sign ups" do
      visit new_user_registration_path

      expect(page).to have_current_path "/sign_up"

      fill_in "Company Name", with: "Test company"
      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"

      click_button "Sign up"

      expect(page).to have_current_path "/"
      # expect(page).to have_css("#flash-container", text: "Welcome! You have signed up successfully.")
      expect(page).to have_button "Log out"
    end
  end

  context "signing up got errors" do
    it "is invalid when company name, email and password are blank" do
      visit new_user_registration_path

      expect(page).to have_current_path "/sign_up"

      fill_in "Company Name", with: ""
      fill_in "Email", with: ""
      fill_in "Password", with: ""

      click_button "Sign up"

      expect(page).to have_content "Can't be blank"
    end

    it "is invalid when email has already been taken" do
      FactoryBot.create(:user,
        email: "tester@example.com",
        password: "password")

      visit new_user_registration_path

      expect(page).to have_current_path "/sign_up"

      fill_in "Company Name", with: "Test company"
      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password"

      click_button "Sign up"

      expect(page).to have_content "Has already been taken"
    end

    it "is invalid when password and password confirmation does not match" do
      visit new_user_registration_path

      expect(page).to have_current_path "/sign_up"

      fill_in "Company Name", with: "Test company"
      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "password"
      fill_in "Password confirmation", with: "password123"

      click_button "Sign up"

      expect(page).to have_content "Doesn't match password"
    end
  end
end
