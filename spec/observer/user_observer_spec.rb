require 'spec_helper'

describe UserObserver do

	before :all do
		@user = build(:user)
#		@user = stub_model(User)
		@observer = UserObserver.instance
	end

	describe "#after_create" do
		it "should invoke after_create action" do
			@user.save
			@observer.after_create(@user)
		end
	end

end
