require "spec_helper"
include Warden::Test::Helpers 

describe User do

	before :each do
		# create factory user
		@user = create(:user)
		login_as(@user, :scope => :user)
	end 

	describe "preferences" do 	
		before :each do
			visit edit_user_path(@user.id)
		end	

		it "can display preferences form" do				
			page.should have_content("Preferences") 
		end

		it "validates passwords only on action create" do
			find("#user_submit_action input").click			
			page.should have_content("Profile successfully updated.")  
		end

		it "can change password" do
			fill_in "Password", :with => "newpassword"
			fill_in "Confirm password", :with => "newpassword"
			click_button "submit_password"
			page.should have_content("Profile successfully updated.")
			last_email.to.should include(@user.email)  
		end
	end
end
