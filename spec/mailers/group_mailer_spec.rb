require 'spec_helper'
 
describe GroupMailer do
	before :each do
		@user = create(:user)
		@anotheruser = create(:user)
		@group = create(:group, user: @user)
	end
	
	describe "anotheruser participates to a group" do

		before :each do
			@grouping = build(:grouping, user: @anotheruser, group: @group, owner: @anotheruser)
		end

		it "sends an e-mail to groupowner after participation request of another user" do
			@mail = GroupMailer.participation_request(@grouping)
			GroupMailer.should_receive(:participation_request, @grouping).and_return(@mail)
			@grouping.save
		  last_email.to.should == [@user.email]
		end

		it "sends an e-mail to requestor after request is accepted by groupowner" do
			@grouping.update_attributes(:accepted => 1, :accepted_at => Time.now)
			@mail = GroupMailer.participation_accepted(@grouping)
			GroupMailer.should_receive(:participation_accepted, @grouping).and_return(@mail)
			@grouping.save				
			@mail.to.should eq([@anotheruser.email])
		end

		it "sends an e-mail to anotheruser when groupowner aborts accepted participation" do
			@grouping.update_attributes(:accepted => 1, :accepted_at => Time.now)
			@mail = GroupMailer.participation_aborted(@grouping)
			GroupMailer.should_receive(:participation_aborted, @grouping).and_return(@mail)
			@grouping.save
			@grouping.destroy
			@mail.to.should eq([@anotheruser.email])
		end

	end

	describe "groupowner invites others" do

		before :each do
			@grouping = build(:grouping, user: @anotheruser, group: @group, owner: nil)
		end

		it "sends an e-mail to anotheruser when groupowner invites him" do
			@mail = GroupMailer.invitation(@grouping)
			GroupMailer.should_receive(:invitation, @grouping).and_return(@mail)
			@grouping.save		
		  @mail.to.should eq([@anotheruser.email])
		end

		it "sends an e-mail to groupowner when anotheruser accepts invitation" do
			@grouping.update_attributes(:accepted => 1, :accepted_at => Time.now)
			@mail = GroupMailer.invitation_accepted(@grouping)
			GroupMailer.should_receive(:invitation_accepted, @grouping).and_return(@mail)			
			@grouping.save			
			@grouping.destroy		
		  @mail.to.should eq([@group.owner.email])
		end

		it "sends an e-mail to groupowner when anotheruser declines invitation" do
			@mail = GroupMailer.invitation_aborted(@grouping)
			GroupMailer.should_receive(:invitation_aborted, @grouping).and_return(@mail)
			@grouping.destroy		
		  @mail.to.should eq([@group.owner.email])
		end

	end
end
