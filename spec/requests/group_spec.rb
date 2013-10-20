require "spec_helper"
include Warden::Test::Helpers 

describe Group do
 
	before :each do
		I18n.locale = :en
		@user = create(:user, :id => Random.rand(1000))
		login_as(@user, :scope => :user)	
		@anotheruser = create(:user, 
													:id => Random.rand(1000),
													:login => "another user",
													:email => "another@email.com"
									)	
		@group = create(:group, :id => Random.rand(1000), :user_id => @anotheruser.id)
	end 

	it "GET user/groups" do
		visit user_groups_path(@user)
#		save_and_open_page	
		page.should have_content("Groups") 
	end

	# this will not work: when clicked on the Participate-Button, user is not logged in anymore	
	#	it "can be participated by another user" do
	#		visit group_path(@group)
	#		click_link "group-participate"		
	#		page.should have_content("Participation sended to group.")
	#		save_and_open_page	
	#	end

#	it "can be created by user" do
#		visit user_groups_path(@user.login)
#		click_link('group-new')				
#		fill_in "group_title", :with => "testgroup"
#		click_button "group-save"
#		@user.groups.count.should == 1	
#	end

#	describe "user participation on groups" do		
#		it "can ask for participation on a group" do
#	    visit "/users/sign_in"
#			page.driver.post user_session_path, :user => {:email => @user.email, :password => @user.password }
#		  fill_in "user_username",    :with => @user.login
#		  fill_in "Password", 		:with => @user.password
#		  click_button "submit"
#			visit group_path(@group)			
#			page.should have_content("Participate")
#			click_link "group-participate"
			#page.should have_content("Participation sended to group.")
#			save_and_open_page	
#		end
#	end

	describe "can be edited by group owner" do
		before :each do
			@user = create(:user, :id => Random.rand(1000))
			login_as(@user, :scope => :user)	
			@group = create(:group, :id => Random.rand(1000), :title => "testgroup", :user_id => @user.id)
			visit group_path(@group)
		end

		it "can show edit form" do
			click_link "group-edit"			
			page.should have_content("Change your group")
#			save_and_open_page	
		end

		it "can change title" do
			click_link "group-edit"			
			fill_in :group_title, :with => "testgroup changed"
			click_button "group-save"
			page.should have_content("testgroup changed")  
      page.should have_content("Successfully updated group.") 
		end
		
		it "can add location" do
			click_link "group-edit"			
			fill_in "Address", :with => "Berlin"
			expect { click_button "group-save" }.to change { @group.locations.count }.by(1)	
      page.should have_content("Location") 
		end

		it "can add tags" do
			click_link "group-edit"			
			fill_in "Tags", :with => "tag1, tag2"
			expect { click_button "group-save" }.to change { @group.tags.count }.by(2)	
			page.should have_content("Tags: tag1 tag2")
		end
	end

end
