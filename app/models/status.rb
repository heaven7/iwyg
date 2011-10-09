class Status < ActiveRecord::Base
  belongs_to :ping
  belongs_to :transfer
end
