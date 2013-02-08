require "spec_helper"
include Warden::Test::Helpers 

describe User do

	before :each do
		# create factory user
		@user = create(:user)
	end 

	describe "#show (profile)" do
		it "can not be seen without login" do
			visit user_path(@user)
			page.should have_content("You need to sign in or sign up before continuing.")
		end
	end

	describe "notifications" do
		it "should have no notifications on create" do
			login_as(@user, :scope => :user)
			@user.notifications.count.should eq 0
			visit user_path(@user)
			page.should have_content("No notifications yet.")
		end
	end

	describe "preferences" do 	
		before :each do
			login_as(@user, :scope => :user)
			visit edit_user_path(@user.id)
		end	

#		it "can change password" do
#			login_as(@user, :scope => :user)
#			visit edit_user_path(@user.id)
#			fill_in "Password", :with => "newpassword"
#			fill_in "Confirm password", :with => "newpassword"
#			click_button "Change password"
#			#save_and_open_page			
#			page.should have_content("Profile successfully updated.")
#			last_email.to.should include(@user.email)  
#		end

		it "can display preferences form" do				
			page.should have_content("Preferences") 
		end

		it "validates passwords only on action create" do
			find("#user_submit_action input").click			
			page.should have_content("Profile successfully updated.")  
		end

	end
end
