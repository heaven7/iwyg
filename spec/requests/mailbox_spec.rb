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

	describe "sending messages" do

		before :each do
			@anotheruser = create(:user, :id => Random.rand(1000))
		end

		it "should send message to anotheruser" do
			visit user_path(@anotheruser)
			click_link "send_message"
			fill_in "message_subject", :with => "hello"
			fill_in "message_body", :with => "World"
			click_button "Abschicken"
			save_and_open_page
		end
	end
end
