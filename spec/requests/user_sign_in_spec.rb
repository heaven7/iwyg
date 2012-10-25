require "spec_helper"

describe "user sign in" do
  it "allows users to sign in after they have registered" do
    user = User.create(:login    => "testuser",
                       :password => "ilovegrapes")

    visit "/users/sign_in"

    fill_in "user_username",    :with => "testuser"
    fill_in "user_password", 		:with => "ilovegrapes"

    click_button "submit"

    page.should have_content("testuser")
  end
end
