require 'spec_helper'

 
describe UserMailer do
  before :each do
    @user = create(:user)
  end

	describe "defaults" do
		it "should have right defaults" do
			UserMailer.default[:css].should be :mailer
			UserMailer.default[:charset].should eq 'UTF-8'
		end
	end
	
 
#  it "sends an e-mail to user after creation" do
#    # @user.send_instructions
#    last_email.to.should == @user.email
#  end
end
