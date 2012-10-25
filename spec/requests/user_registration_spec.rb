require "spec_helper"

describe "user registration" do
  it "allows new users to register with an login, email address and password" do
    visit "/users/sign_up"

		fill_in "user_login",	   						  :with => "flower"
    fill_in "user_email",                 :with => "alindeman@example.com"
    fill_in "user_password",              :with => "ilovegrapes"
    fill_in "user_password_confirmation", :with => "ilovegrapes"

    click_button "submit"

    page.should have_content("flower")
  end
end
