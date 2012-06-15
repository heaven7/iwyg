class Meeting < ActiveRecord::Base
  attr_accessible :invited_user_id, :user_id, :meetup_id, :accepted, :accepted_at, :invited, :invited_at
  belongs_to :user
  belongs_to :meetup

  # scopes
  scope :invited, :conditions => {:invited => true}
  scope :accepted, :conditions => {:accepted => true}

  def accepted_already?
   not Meeting.find_by_meetup_id_and_user_id_and_accepted(self.meetup_id, self.user_id, true).nil?
  end
end
