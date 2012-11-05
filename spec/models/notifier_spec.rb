require 'spec_helper'

describe Notifier do

	before :all do
		@notifier = build(:notifier)
	end 

	subject { @notifier }

	it { should belong_to(:user) }
	
	describe "validations" do
		
		it "should be valid" do
			@notifier.should be_valid
		end

		it "has a valid factory" do
			@notifier.should be_valid
		end

		describe "invalidity" do
				
			before :all do
				@notifier = Notifier.new
			end			
						
			it "is invalid without a user_id" do
				@notifier.user_id = nil
				@notifier.should_not be_valid
			end


			it "is invalid without a notifyable_id" do
				@notifier.notifyable_id = nil
				@notifier.should_not be_valid
			end

			it "is invalid without a notifyable_type" do
				@notifier.notifyable_type = nil
				@notifier.should_not be_valid
			end

		end

	end
end
