class ActionsController < InheritedResources::Base

  before_filter :authenticate_application_user!, :only => [:edit]
  respond_to :html, :xml, :json, :js
end
