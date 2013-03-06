require "spec_helper"
include Warden::Test::Helpers 

describe User do
 
	before :each do
		@user = create(:user, :id => Random.rand(1000))
		login_as(@user, :scope => :user)
	end

	describe "mailbox views" do 
		
		before :each do
			@mailbox = @user.inbox
			visit mailbox_path(@mailbox)
		end

		it "GET mailbox content" do
			page.should have_content("Mailbox") 
		end

		it "GET inbox" do
			click_link "Inbox"
	#		save_and_open_page
			page.should have_content("Messages (0)") 
		end

		it "GET sent messages" do
			click_link "Sent"
			page.should have_content("Mailbox") 
			page.should have_content("Messages (0)") 
		end
	end

end
