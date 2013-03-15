require "spec_helper"
include Warden::Test::Helpers 

describe Item do

	before :each do
		# create factories
		@user = create(:user)
		@itemtype = create(:item_type, :good)
		@item = create(:item, user_id: @user.id, item_type_id: @itemtype.id, need: false, itemable: @user)
		login_as(@user, :scope => :user)
	end 

	describe "get items" do 	
		it "can display all items" do
			visit items_path
			page.should have_content("a testitem")
		end
	end

	describe "show one item" do
		before :each do
			visit items_path(@item)
			click_link "a testitem" 	
		end

		it "should display ping form" do
			page.should have_content("I need") 
		end

		it "can view a item" do			
			page.should have_content("a testitem") 
#			save_and_open_page	
		end
	end
end
