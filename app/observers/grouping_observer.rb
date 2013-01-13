class GroupingObserver < ActiveRecord::Observer
	observe :grouping

	def after_create(grouping)
		if grouping.owner != nil
			GroupMailer.participation_request(grouping).deliver
		else
			GroupMailer.invitation(grouping).deliver
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
		if grouping.owner != nil or grouping.accepted?
			GroupMailer.participation_aborted(grouping).deliver
		else			
			GroupMailer.invitation_aborted(grouping).deliver
		end
	end
end
