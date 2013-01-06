require "spec_helper"
include Warden::Test::Helpers 

describe Group do
 
	before :each do
		@user = create(:user, :id => Random.rand(1000))
		login_as(@user, :scope => :user)	
		@anotheruser = User.create( 
													:id => Random.rand(1000),
													:login => "another user",
													:email => "another@email.com",
												  :password => "anotherpassword", 
													:password_confirmation => "anotherpassword",
													:confirmed_at => Time.now
									)	
		@group = create(:group, :id => Random.rand(1000), :user_id => @anotheruser.id)
	end 

	it "GET user/groups" do
		visit "/users/#{@user.login}/groups"
		page.should have_content("Groups") 
	end

	# this will not work: when clicked on the Participate-Button, user is not logged in anymore	
	#	it "can be participated by another user" do
	#		visit group_path(@group)
	#		click_link "group-participate"		
	#		page.should have_content("Participation sended to group.")
	#		save_and_open_page	
	#	end

	it "can be created by user" do
		visit user_groups_path(@user.login)
		click_link('group-new')				
		fill_in "group_title", :with => "testgroup"
		expect { click_button "group-save" }.to change { @user.groups.count }.by(1)	
		page.should have_content("Successfully saved group.")
	end

	describe "can be edited by group owner" do
		before :each do
			@user = create(:user, :id => Random.rand(1000))
			login_as(@user, :scope => :user)	
			@group = create(:group, :id => Random.rand(1000), :title => "testgroup", :user_id => @user.id)
			visit group_path(@group)
#			save_and_open_page	
			click_link "group-edit"			
		end

		it "can show edit form" do
			page.should have_content("Change your group")
		end

		it "can change title" do
			fill_in :group_title, :with => "testgroup changed"
			click_button "group-save"
			page.should have_content("testgroup changed")  
      page.should have_content("Successfully updated group.") 
		end
		
		it "can add location" do
			fill_in "Address", :with => "Berlin"
			expect { click_button "group-save" }.to change { @group.locations.count }.by(1)	
      page.should have_content("Location") 
		end

		it "can add tags" do
			fill_in "Tags", :with => "tag1, tag2"
			expect { click_button "group-save" }.to change { @groups.count }.by(2)	
			click_button "group-save"
			page.should have_content("Tags: tag1 tag2")
		end
	end

end
