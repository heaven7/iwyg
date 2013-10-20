require 'spec_helper'

describe Message do


	before :all do
		@sender = create(:user)
		@message = build(:message, author: @sender)
		@receiver = create(:user)
		@message2 = create(:message, author: @sender, to: @receiver.login)
	end 

	subject { @message }

	it { should belong_to(:author) }
	it { should have_many(:message_copies) }
	it { should have_many(:recipients).through(:message_copies) }
	it { should have_one(:custom) }
	
	describe "validations" do
		
		it "should be valid" do
			@message.should be_valid
		end

		it "has a valid factory" do
			@message.should be_valid
		end
	
		it "has an author" do
			@message.author.should be @sender	
		end

		it "has a subject" do
			@message.subject.should == "test message"	
		end

		it "has a body" do
			@message.body.should == "the body of the test message"	
		end

		it 'is invalid without a subject' do
			message = Message.new
			message.should_not be_valid
		end

	end

	describe "sending messages" do

		it "sender has sent a message" do
			@sender.sent_messages.count.should == 1
		end 
			
		it "receiver gets the message" do
			@receiver.received_messages.count.should == 1
		end

		it "receiver can reply to user" do
			@original = @receiver.received_messages.first
			@message = create(
				:message,
				id: Random.rand(1000), 
				to: @sender.login, 
				subject: @original.subject, 
				body: "this is a reply"
			)
			@sender.received_messages.count.should be 1
		end
	end

	

end
