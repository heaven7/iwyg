require 'spec_helper'

describe GroupingObserver do

	before :each do
		@user = build(:user)
		@anotheruser = build(:user)
		@group = build(:group, user: @user)
		@observer = GroupingObserver.instance
	end

	it "#after_create" do
		@grouping = build(:grouping, group: @group, user: @anotheruser, owner: @user)
		@observer.should_receive(:after_create).once
		@grouping.save
	end

	it "#after_update" do
		@grouping = create(:grouping, group: @group, user: @anotheruser, owner: @user)
		@observer.should_receive(:after_update).once
		@grouping.update_attributes(accepted_at: Time.now)
	end

	it "#after_destroy" do
		@grouping = create(:grouping, group: @group, user: @anotheruser, owner: @user)
		@observer.should_receive(:after_destroy).once
		@grouping.destroy
	end

end
