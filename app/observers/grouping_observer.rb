class GroupingObserver < ActiveRecord::Observer
	observe :grouping

	def after_create(grouping)
		GroupMailer.participation_request(grouping).deliver
	end

	def after_update(grouping)
		g = grouping
		if g.accepted?
			GroupMailer.participation_accepted(grouping).deliver
		end
	end

	def after_destroy(grouping)
		GroupMailer.participation_aborted(grouping).deliver
	end
end
