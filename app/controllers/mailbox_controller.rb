class MailboxController < InheritedResources::Base

  layout 'mailbox'
  helper :users

    
  def index
    @user = current_user
    redirect_to new_session_path and return unless logged_in?
    @folder = current_user.inbox
    show
    render :action => "show"
  end

  def show
    @user = current_user
    @folder ||= @user.folders.find(params[:id])
    @messages = @folder.messages.paginate :per_page => 10, :page => params[:page], :include => :message, :order => "messages.created_at DESC" if @folder.messages
  end
    
end
