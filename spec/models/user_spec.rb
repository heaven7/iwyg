require 'spec_helper'

describe User do

	before :all do
		@user = build(:user)
	end 

	subject { @user }

	it "should be valid" do
		@user.should be_valid
	end
	
	it "has a login length gt 3" do
		@user.login.length.should be >= 3	
	end

	it "has a login length <= 40" do
		@user.login.length.should be <= 40 
	end

	it "has a password length >= 4" do
		 @user.password.length.should be >= 4 
	end	

	it "has a password length <= 40" do
		@user.password.length.should be <= 40
	end

	it "has a email length >= 3" do
		@user.email.length.should be >= 3
	end

	it "has a email length <= 100" do
		@user.email.length.should be <= 100
	end

	it "has a equal password and password_confirmation" do
		@user.password.should eq(@user.password_confirmation)
	end

	it "has a id > 0" do
		@user.id.should be > 0
	end

	describe "with an inbox" do
		before :each do 
			@folder = create(:folder, user_id: @user.id)
		end

		it "is the users inbox" do
			@folder.user_id.should eq(@user.id)
			@user.inbox
		end
		
		it "is titled inbox" do
			@folder.title.should == "Inbox"
		end
	end
end
