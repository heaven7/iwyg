require 'spec_helper'

describe Notification do

  before(:each) do
    @user = create(:user)
    @notification = FactoryGirl.build(:notification, :receiver => @user)
  end

	it "is not valid without notifiable_id" do
    @notification.notifiable_id = nil
    @notification.should_not be_valid
  end
  
  it "is not valid without notifiable_type" do
    @notification.notifiable_type = nil
    @notification.should_not be_valid
  end
  
  it "is valid without description" do
    @notification.description = nil
    @notification.should be_valid
  end
  
#  it "is not valid if the same notification already exists" do
#    @notification2 = create(:notification, :receiver => @user)
#    @notification.should_not be_valid
#    @notification2.update_attribute(:created_at, 1.day.ago)
#    @notification.should be_valid
#  end

end
