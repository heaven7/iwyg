class MeetupObserver < ActiveRecord::Observer
  observe :meetup

  def after_create(meetup)
    owner = meetup.owner
    meetup.users.each do |member|
      MeetupMailer.invitation(meetup, member, owner).deliver unless member == owner
    end
  end
end
