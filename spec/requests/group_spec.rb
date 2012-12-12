require "spec_helper"
include Warden::Test::Helpers 

describe Group do
 
	before :each do
		# create factory user
		@user = create(:user)
		login_as(@user, :scope => :user)	
		@anotheruser = User.create( 
													:id => Random.rand(1000),
													:login => "another user",
													:email => "another@email.com",
												  :password => "anotherpassword", 
													:password_confirmation => "anotherpassword",
													:confirmed_at => Time.now
									)	
		@group = create(:group, :user_id => @anotheruser.id)
	end 

	it "GET user/groups" do
		visit "/users/#{@user.login}/groups"
		page.should have_content("Groups") 
	end

	it "can be participated by another user" do
			
			visit group_path(@group)
	#			visit "/groups/#{@group.slug}"
			# this will not work, when clicked on the Participate-Button, user is not logged in anymore
			#click_link "another user"
	#			click_link "Participate"
	#			login_as(@user, :scope => :user)			
	#			visit "/groups/#{@group.slug}"			
	#		click_link "group-participate"
		
	#			page.should have_content("Participation sended to group.")
			save_and_open_page	
	end

	describe "Groups" do

		it "can be created by a user" do
			visit user_groups_path(@user.login)
			click_link('group-new')				
			fill_in "group_title", :with => "testgroup"
			expect { click_button "group-save" }.to change { @user.groups.count }.by(1)	
			page.should have_content("Successfully saved group.")
		end
	end

end
