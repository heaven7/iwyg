class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true

  acts_as_audited
  validates_presence_of :body
end
