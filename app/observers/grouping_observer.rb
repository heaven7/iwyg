class GroupingObserver < ActiveRecord::Observer
	observe :grouping

	TYPE = "Group"

	def after_create(grouping)
		@g = grouping

		if @g.owner != nil
			# groupowner gets noticed, when someone wants to join the group
			@sender = @g.user
			@receiver  = @g.group.owner
			@email_subject = "mailer.group.participation_request"
			
			getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
			GroupMailer.participation_request(@g, @sender, @receiver, @subject).deliver
		else
			# user gets noticed, when groupowner invites user
			@sender = @g.group.owner
			@receiver = @g.user
			@email_subject = "mailer.group.invitation"
			
			getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)					
			GroupMailer.invitation(@g, @sender, @receiver, @subject).deliver
		end
	end

	def after_update(grouping)
		@g = grouping

		if @g.accepted?
			if @g.owner != nil
				@sender = @g.group.owner
				@receiver = @g.user
				@email_subject = "mailer.group.participation_accepted"

				getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
				GroupMailer.participation_accepted(@g, @sender, @receiver, @subject).deliver
			else
				@sender = @g.user
				@receiver = @g.group.owner
				@email_subject = "mailer.group.invitation_accepted"
		
				getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
				GroupMailer.invitation_accepted(@g, @sender, @receiver, @subject).deliver
			end
		end
	end

	def after_destroy(grouping)
		@g = grouping

		if @g.accepted?

			if @g.group.owner == @g.quit_by
				@sender = @g.group.owner
				@receiver = @g.user
				@email_subject = "mailer.group.quit_membership_by_owner"

				getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
				GroupMailer.quit_membership_by_owner(@g, @sender, @receiver, @subject).deliver
			else
				@sender = @g.user
				@receiver = @g.group.owner
				@email_subject = "mailer.group.quit_membership"

				getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
				GroupMailer.quit_membership(@g, @sender, @receiver, @subject).deliver
			end 

		else

			if @g.owner == nil
				
				@sender = @g.quit_by
				@receiver = @sender == @g.group.owner ? @g.user : @g.group.owner
				@email_subject = "mailer.group.invitation_aborted"
				getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
				GroupMailer.invitation_aborted(@g, @sender, @receiver, @subject).deliver
				
			else		
				
				@sender = @g.quit_by
				@receiver = @sender == @g.user ? @g.group.owner : @g.user
				@email_subject = "mailer.group.participation_aborted"
				getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
				GroupMailer.participation_aborted(@g, @sender, @receiver, @subject).deliver			

			end
		end			
	end

	private

	def getSubjectAndNotification(email_subject, sender, receiver, group)
		
		@subject = I18n.t(email_subject, :sender => sender.login, :title => group.title).html_safe
		Notification.new(
								 :sender => sender, 
								 :receiver => receiver, 
								 :notifiable_id => group.id, 
								 :notifiable_type => TYPE,
								 :title => @subject
		).save		

	end

end
