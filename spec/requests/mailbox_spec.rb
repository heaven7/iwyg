require "spec_helper"
include Warden::Test::Helpers 

describe User, :type => :request do
 
	before :each do
		@user = create(:user, :id => Random.rand(1000))
		login_as(@user, :scope => :user)
		I18n.locale = :en
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
			click_link "inbox"
  		#save_and_open_page
			page.should have_content("Messages (0)") 
		end

		it "GET sent messages" do
			click_link "outbox"
			page.should have_content("Mailbox") 
			page.should have_content("Messages (0)") 
		end
	end

	describe "sending messages (with javascript)" do

		before :all do
			@anotheruser = create(:user, :id => Random.rand(1000))

		end

		it "should send message to anotheruser", :js => true do
			visit user_path(@anotheruser)
			click_link "send_message"
			fill_in "message_subject", :with => "hello"
			fill_in "message_body", :with => "World"
			click_button "submit_new_message"
			page.should have_content("Message sent")
		end

		it "should reply to received message", :js => true do
			login_as(@anotheruser, :scope => :user)
			@messageparams = { :author => @user, :to => @anotheruser.login, :subject => "message from user", :body => "whats up?" }
			@message = @user.sent_messages.build(@messageparams).save			

			visit mailbox_path(@anotheruser)
			page.should have_content("Messages (1)") 
			click_link "message from user"
			fill_in "message_body", :with => "this is the reply from another user"
			click_button "submit_reply_message"
			page.should have_content("Message replied")
		end
	end
end
