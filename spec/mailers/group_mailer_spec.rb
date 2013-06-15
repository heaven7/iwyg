require 'spec_helper'
 
describe GroupMailer do

	before :each do
		@user = create(:user)
		@anotheruser = create(:user)
		@group = create(:group, user: @user)
	end

	describe "defaults" do
		it "should have right defaults" do
			GroupMailer.default[:css].should be :mailer
			GroupMailer.default[:charset].should eq 'UTF-8'
		end
	end
	
	describe "anotheruser participates to a group" do

		before :each do
			login_as(@anotheruser, :scope => :user)	

			@grouping = build(:grouping, user: @anotheruser, group: @group, owner: @anotheruser)
		end

		it "sends an e-mail to groupowner after participation request of another user" do
			@receiver = @grouping.group.owner
			@sender = @anotheruser
			@subject = "mailer.group.participation_request"
			@mail = GroupMailer.participation_request(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:participation_request).and_return(@mail)
			@grouping.save
		  last_email.to.should == [@user.email]
		end

		it "sends an e-mail to requestor after request is accepted by groupowner" do
			@grouping.update_attributes(:accepted => 1, :accepted_at => Time.now)
			@receiver = @grouping.user
			@sender = @user			
			@subject = "mailer.group.participation_accepted"
			@mail = GroupMailer.participation_accepted(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:participation_accepted).and_return(@mail)
			@grouping.save				
			@mail.to.should eq([@anotheruser.email])
		end

		it "sends an e-mail to anotheruser when groupowner declines participation" do
			@grouping.quit_by = @user
			@receiver = @grouping.user
			@sender = @user
			@subject = "mailer.group.participation_aborted"
			@mail = GroupMailer.participation_aborted(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:participation_aborted).and_return(@mail)
			@grouping.destroy		
		  @mail.to.should eq([@anotheruser.email])
		end

		it "sends an e-mail to groupowner when user aborts participation" do
			@grouping.quit_by = @user
			@receiver = @grouping.group.owner
			@sender = @anotheruser
			@subject = "mailer.group.participation_aborted"
			@mail = GroupMailer.participation_aborted(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:participation_aborted).and_return(@mail)
			@grouping.destroy		
		  @mail.to.should eq([@grouping.group.owner.email])
		end

	end

	describe "groupowner invites others" do

		before :each do
			login_as(@user, :scope => :user)	
			@grouping = build(:grouping, user: @anotheruser, group: @group, owner: nil)
		end

		it "sends an e-mail to anotheruser when groupowner invites him" do
			@receiver = @grouping.user
			@sender = @user
			@subject = "mailer.group.invitation"			
			@mail = GroupMailer.invitation(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:invitation).and_return(@mail)
			@grouping.save		
		  @mail.to.should eq([@anotheruser.email])
		end

		it "sends an e-mail to groupowner when anotheruser accepts invitation" do
			@grouping.update_attributes(:accepted => 1, :accepted_at => Time.now)
			@receiver = @grouping.group.owner
			@sender = @anotheruser
			@subject = "mailer.group.invitation_accepted"
			@mail = GroupMailer.invitation_accepted(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:invitation_accepted).and_return(@mail)			
			@grouping.save			
			@grouping.destroy		
		  @mail.to.should eq([@group.owner.email])
		end

		it "sends an e-mail to groupowner when anotheruser declines invitation" do
			@grouping.quit_by = @anotheruser			
			@receiver = @grouping.group.owner
			@sender = @user
			@email_subject = "mailer.group.invitation_aborted"
			@mail = GroupMailer.invitation_aborted(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:invitation_aborted).and_return(@mail)
			@grouping.destroy		
		  @mail.to.should eq([@group.owner.email])
		end

	end

	describe "anotheruser quits group membership" do

		it "sends an e-mail to groupowner" do
			@grouping = create(:grouping, user: @anotheruser, group: @group, owner: nil, :accepted => 1, :accepted_at => Time.now)
			@grouping.update_attributes(:quit_by => @anotheruser)
			@receiver = @grouping.group.owner
			@sender = @anotheruser
			@subject = "mailer.group.quit_membership"
			@mail = GroupMailer.quit_membership(@grouping, @sender, @receiver, @subject)

			GroupMailer.should_receive(:quit_membership).and_return(@mail)
			@grouping.destroy
			@mail.to.should eq([@group.owner.email])
		end

	end

	
	describe "groupowner quits group membership" do

		it "sends an e-mail to anotheruser" do
			@grouping = create(:grouping, user: @anotheruser, group: @group, owner: nil, :accepted => 1, :accepted_at => Time.now)
			@grouping.update_attributes(:quit_by => @grouping.group.owner)
			@receiver = @grouping.user
			@sender = @user
			@subject = "mailer.group.quit_membership_by_owner"

			@mail = GroupMailer.quit_membership_by_owner(@grouping, @sender, @receiver, @subject)
			GroupMailer.should_receive(:quit_membership_by_owner).and_return(@mail)
			@grouping.destroy
			@mail.to.should eq([@anotheruser.email])
		end

	end

end
