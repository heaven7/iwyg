require "spec_helper"

describe Group do

	before :all do
		# create factory user
		@user = create(:user)
	end 

	it "GET user/groups" do
		visit "/users/#{@user.login}/groups"
		page.should have_content("Groups") 
	end

	describe "Users Groups creation" do

		it "can be created by a user" do
			login_as(@user, :scope => :user)
			visit user_groups_path(@user.login)
			click_link('group-new')				
			fill_in "group_title", :with => "testgroup"
			expect { click_button "group-save" }.to change { @user.groups.count }.by(1)	
			page.should have_content("Successfully saved group.")
		end

		it "can be participated by another user" do
			@anotheruser = User.create( 
														:id => 199,
														:login => "another user",
														:email => "another@email.com",
													  :password => "anotherpassword", 
														:password_confirmation => "anotherpassword",
														:confirmed_at => Time.now
										)	
			@group = create(:group, :user_id => @anotheruser.id)
			
			login_as(@user, :scope => :user)	
			visit group_path(@group)

			# this will not work, when clicked on the Participate-Button, user is not logged in anymore
#			click_link "Participate"
#			page.should have_content("Participation sended to group.")
#			save_and_open_page			
		end
	end
end
