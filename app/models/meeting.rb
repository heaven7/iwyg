class Meeting < ActiveRecord::Base
  attr_accessible :user_id, :meetup_id
  belongs_to :user
  belongs_to :meetup

  def exists?
   not Ping.find_by_pingable_id_and_pingable_type_and_user_id(self.pingable_id, self.pingable_type, self.user_id).nil?
  end 

end
