require 'rails_helper'

RSpec.describe "Sign Ins", type: :system do
  context "as a user" do
    before do
      FactoryBot.create(:user,
        email: "tester@example.com",
        password: "password")
    end

    it "successfully signs in" do
      visit root_path

      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "password"

      click_button "Sign in"

      expect(page).to have_current_path "/"
      expect(page).to have_css("#flash-container", text: "Signed in successfully.")
      expect(page).to have_button "Log out"
    end
  end

  context "signing in got errors" do
    it "is invalid when email and password is blank" do
      visit root_path

      fill_in "Email", with: ""
      fill_in "Password", with: ""

      click_button "Sign in"

      expect(page).to have_css("#flash-container", text: "Invalid Email or password.")
    end

    it "is invalid when password is incorrect" do
      visit root_path

      fill_in "Email", with: "tester@example.com"
      fill_in "Password", with: "password123"

      click_button "Sign in"

      expect(page).to have_css("#flash-container", text: "Invalid Email or password.")
    end
  end
end
