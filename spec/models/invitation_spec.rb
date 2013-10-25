require 'spec_helper'

describe Invitation do

	before :all do
		@invitation = create(:invitation)
	end 

	subject { @invitation }

	it { should belong_to(:sender).class_name('User') }
	it { should have_many(:friendships).class_name('Friendship') }

	describe "validations" do

		it "should be valid" do
			@invitation.should be_valid
		end
	
		it "should not be valid without emails" do
			@invitation.emails = ""
			@invitation.should_not be_valid
		end

		it "should not be valid without invitationmessage" do
			@invitation.invitationmessage = ""
			@invitation.should_not be_valid
		end

#		it "should not be valid if email is already registered"
	end

	describe "methods" do
	
	end

end
