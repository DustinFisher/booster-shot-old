require 'rails_helper'

describe "AccountCreation", :type => :feature do
  scenario "should allow the visitor to create an account" do
    visit new_user_registration_path

    fill_in "Email", :with => "citra@hops.com"
    fill_in "Password", :with => "$1234567$"
    fill_in "Password confirmation", :with => "$1234567$"

    click_button "Sign up"
    expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
  end

  scenario "should allow the user to change their password" do
    @user = create(:user)
    login_as(@user, scope: :user)

    visit edit_user_registration_path

    fill_in "Password", :with => "3lit3pa$$"
    fill_in "Password confirmation", :with => "3lit3pa$$"
    fill_in "Current password", :with => @user.password

    click_button "Update"
    expect(page).to have_content('Your account has been updated successfully.')
  end
end
