require "spec_helper"

describe User do
	
	before :all do
		# create factory user
		@user = create(:user)

	end 

	describe "GET user/edit" do
		it "displays user preferences form" do
			# user sign in
			visit "/users/sign_in"
		  fill_in "user_username",    :with => @user.login
		  fill_in "user_password", 		:with => @user.password
		  click_button "submit"
				
			visit edit_user_path(@user.id)
			page.should have_content("Preferences") 
		end
	end

	describe "POST user/edit" do
		it "validates passwords only on action create" do
			# user sign in
			visit "/users/sign_in"
		  fill_in "user_username",    :with => @user.login
		  fill_in "user_password", 		:with => @user.password
		  click_button "submit"

			visit "/users/#{@user.id}/edit"
			find("#user_submit_action input").click			
			page.should have_content("Profile successfully updated.")  
		end
	end

end
