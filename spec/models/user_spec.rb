require 'spec_helper'

describe User do

	before :all do
		@user = FactoryGirl.build(:user)
	end 

	subject { @user }
	it "should be valid" do
		@user.should be_valid
	end

	it "has a valid factory" do
		@user.should be_valid
	end
	
	it "has a login length gt 3" do
		@user.login.length.should be >= 3	
	end

	it "has a login length lt 40" do
		@user.login.length.should be <= 40 
	end	
	
	it "has a password length gt 4" do
		 @user.password.length.should be >= 4 
	end	

	it "has a password length lt 40" do
		@user.password.length.should be <= 40
	end

	it "has a email length gt 3" do
		@user.email.length.should be >= 3
	end

	it "has a email length lt 100" do
		@user.email.length.should be <= 100
	end

	it "has a equal password and password_confirmation" do
		@user.password.should eq(@user.password_confirmation)
	end

	it "has a id gt 0" do
		@user.id.should be > 0
	end

	describe "#inbox" do
		before :each do 
			@inbox = Folder.new(:user_id => @user.id)
		end
		
		it "has an inbox" do
			@inbox.user_id should eq(@user.id)
		end
	end
end
