class GroupingObserver < ActiveRecord::Observer
	observe Grouping

	def after_create(grouping)
		GroupMailer.participation(grouping).deliver
	end

end
