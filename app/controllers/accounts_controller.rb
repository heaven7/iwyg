class AccountsController < InheritedResources::Base
  layout 'application'
  respond_to :html, :xml, :json
  
  has_scope :taken
  has_scope :given
end
