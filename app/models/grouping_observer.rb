class GroupingObserver < ActiveRecord::Observer
	observe Grouping

	after_create(grouping)
		GroupMailer.participation(grouping).deliver
	end

end
