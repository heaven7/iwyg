class TagsController < InheritedResources::Base

  respond_to :js, :json, :only => :index

  def index
    @context = params[:c]    
    #@tags = Tag.find(:all, :conditions => ['name LIKE ?', "%#{params[:term]}%"])
    #@tags = User.tag_counts_on(@context)
    @tags = ["ene", "mene", "muh"]
    respond_to do |format|
      format.js { render :layout => false }
      format.json { render :layout => false }
    end
  end
end