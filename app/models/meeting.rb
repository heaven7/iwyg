class Meeting < ActiveRecord::Base
  attr_accessible :user_id, :meetup_id
  belongs_to :user
  belongs_to :meetup

end
