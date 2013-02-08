class Account < ActiveRecord::Base
	belongs_to :accountable, :polymorphic => true

end
