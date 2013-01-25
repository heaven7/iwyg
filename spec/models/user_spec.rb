require 'spec_helper'

describe User do

	before :all do
		@user = build(:user)
	end 

	subject { @user }

	it { should have_many(:notifications).dependent(:destroy) }

	describe "validations" do

		it "should be valid" do
			@user.class.should == User
			@user.should_not be_nil
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
			@user.id.should_not == 0
		end
	end

	describe "#create" do

		before :each do 
			@user = create(:user)
		end

		it "should create a user in db" do
			User.find(@user).should_not be nil
		end
	
		it "should raise error if creation failed for invalid data" do
      expect {create(:user, email: "invalid-email")}.to raise_error(ActiveRecord::RecordInvalid)
    end

		it "should also create the users preferences" do
			@user.user_preferences.should_not be nil
		end

		it "should also create the users details" do			
			@user.userdetails.should_not be nil
		end

		it "should also create the users custom" do
			@user.custom.should_not be nil
		end

		it "should also create the users location" do
			@user.location.should_not be nil
		end

		it "should also create the users folder" do
			@user.folders.should_not be nil
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
	
	describe "#update" do
		before :all do 
			login_as(@user)
		end

		it "should update the user attributes" do
      @user.update_attributes({
				'login' => "Test123", 
        'email' => "test@west.com",
				'password' => "newpass", 
        'password_confirmation' => "newpass"
			})
      @user.login.should == "Test123"
      @user.email.should == "test@west.com"
			@user.password == "newpass"
    end
	end

end
