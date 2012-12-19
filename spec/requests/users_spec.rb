require "spec_helper"
include Warden::Test::Helpers 

describe User do

	before :each do
		# create factory user
		@user = create(:user)
		login_as(@user, :scope => :user)
		visit edit_user_path(@user.id)
	end 

	describe "preferences" do 	
		
		it "can display preferences form" do				
			page.should have_content("Preferences") 
		end

		it "validates passwords only on action create" do
			find("#user_submit_action input").click			
			page.should have_content("Profile successfully updated.")  
#			save_and_open_page	
		end

	end
end
