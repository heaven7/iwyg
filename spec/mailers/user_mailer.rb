require 'spec_helper'
 
describe UserMailer do
  before :each do
    @user = create(:user)
  end
 
  it "sends an e-mail to user after creation" do
    # @user.send_instructions
    ActionMailer::Base.deliveries.last.to.should == [@user.email]
  end
end
