class Comment < ActiveRecord::Base
  belongs_to :commentable, :polymorphic => true

  include RailsSettings::Extend 

  acts_as_audited
  acts_as_paranoid
  validates_presence_of :body
end
