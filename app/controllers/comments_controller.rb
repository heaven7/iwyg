class CommentsController < InheritedResources::Base
  layout 'application'
  respond_to :html, :xml
  # respond_to :js, :only => :create
  
  belongs_to :commentable, :polymorphic => true
  
  
  before_filter :login_required, :exept => [:index, :show]
  
  def index
    @commentable = find_commentable
    if @commentable
      @comments = @commentable.comments
    else
      @comments = Comment.all
    end
  end
  
  
  def new
    @commentable = find_commentable
    @comment = Comment.new
  end
  
  
  def edit
    @comment = Comment.find(params[:id])
  end
  
  
  def show
    @comment = Comment.find(params[:id])
  end
  
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.create(params[:comment])
    @comments = @commentable.comments
    
    if @comment.save
     # flash[:notice] = "Comment saved."
     redirect_to @commentable
    else
      render :action => 'new'
    end
  end
  
  def update
    @comment = Comment.find(params[:id])
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Successfully updated comment."
      redirect_to @parent_url
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    flash[:notice] = "Successfully destroyed comment."
    redirect_to collection_url
  end
 
  
  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
