class MeasuresController < InheritedResources::Base

  layout 'application'
  respond_to :html, :xml, :json
  before_filter :login_required

 end
