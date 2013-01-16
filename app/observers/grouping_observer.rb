class GroupingObserver < ActiveRecord::Observer
	observe :grouping

	TYPE = "Group"

	def after_create(grouping)
		@g = grouping

		if grouping.owner != nil
			# groupowner gets noticed, when someone wants to join the group
			@sender = @g.user
			@receiver  = @g.group.owner
			@email = "#{@receiver.login} <#{@receiver.email}>"
			@email_subject = "mailer.group.participation_request"
			
			getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)
			GroupMailer.participation_request(@g, @email, @subject).deliver
		else
			# user gets noticed, when groupowner invites user
			@sender = @g.group.owner
			@receiver = @g.user
			@email = "#{@receiver.login} <#{@receiver.email}>"
			@email_subject = "mailer.group.invitation"
			
			getSubjectAndNotification(@email_subject, @sender, @receiver, @g.group)					
			GroupMailer.invitation(@g, @email, @subject).deliver
		end
	end

	def after_update(grouping)
		if grouping.accepted?
			if grouping.owner != nil
				GroupMailer.participation_accepted(grouping).deliver
			else
				GroupMailer.invitation_accepted(grouping).deliver
			end
		end
	end

	def after_destroy(grouping)
		if grouping.accepted?
			if grouping.group.owner == grouping.quit_by
				GroupMailer.quit_membership_by_owner(grouping).deliver
			else
				GroupMailer.quit_membership(grouping).deliver
			end 
		else
			if grouping.owner != nil	
				GroupMailer.participation_aborted(grouping).deliver			
			else
				GroupMailer.invitation_aborted(grouping).deliver
			end
		end			
	end

	private

	def getSubjectAndNotification(email_subject, sender, receiver, group)
		
		@subject = I18n.t(email_subject, :sender => sender.login, :title => group.title).html_safe
		Notification.new(:receiver => receiver, 
								 :notifiable_id => group.id, 
								 :notifiable_type => TYPE,
								 :title => @subject
		).save		

	end

end
