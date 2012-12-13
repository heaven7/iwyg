class GroupingsController < InheritedResources::Base

  actions :create, :accept, :destroy

  layout 'userarea'
  before_filter :login_required, :except => [:index]
  
  has_scope :pending
  
  def create
		@group = Group.find(params[:group_id])
    @user = current_user
    @grouping = @group.groupings.build(:user_id => @user.id, :owner_id => current_user.id)
    respond_to do |format|
      if !@grouping.exists? && @grouping.save
        flash[:notice] = t("flash.groupings.create.notice")
        format.html { redirect_to([@group]) }
      else
        flash[:error] = t("flash.groupings.create.error")
        format.html { redirect_to(@group) }
      end
    end
  end

  def accept
    @grouping = Grouping.find(params[:id])
		@group = Group.find(@grouping.group_id)

		puts "Grouping: " + @grouping.inspect.to_s
    if @grouping and (@group.owner == current_user or @grouping.owner == nil)
      @grouping.update_attributes(:accepted_at => Time.now, :accepted => 1)
      #@grouping.update_attribute(:accepted_at, Time.now)
      flash[:notice] = t("flash.groupings.accept.notice")
    else
      flash[:error] = t("flash.groupings.accept.error")
    end
    redirect_to ([@group])
  end

  def destroy
    @grouping = Grouping.find(params[:id])
		@group = Group.find(@grouping.group_id)
    @grouping.destroy
    flash[:notice] = t("flash.groupings.destroy.notice")
    redirect_to ([@group])
  end
  
end
