require 'spec_helper'

describe Ping do

	before :each do
		@item_type = build(:item_type)
		@owner = build(:user)
		@pinger = build(:user)
		@item = build(:item, user: @owner, title: "testitem", item_type: @item_type)
		@ping = build(:ping, user: @pinger, pingable: @item)
	end 

	subject { @ping }

	it { should belong_to(:pingable) }
	it { should have_many(:comments) }
	it { should have_one(:event) }

	it "should have settings" do
		@ping.settings.all.size.should eq(0)
	end  
		
	describe "validations" do
		
		it "should be valid" do
			@ping.should be_valid
		end

	end

end
