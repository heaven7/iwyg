require 'spec_helper'

describe Message do

	before :all do
		@message = build(:message)
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
end
