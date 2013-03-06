class MailboxController < InheritedResources::Base

  layout 'mailbox'
  helper :users

  before_filter :authenticate_user!
    
  def index
    redirect_to new_session_path and return unless logged_in?
    @folder = current_user.inbox
#    show
    render :action => "show"
  end

  def show
    @user = current_user
    @folder = @user.inbox
    @messages = @folder.messages.paginate :per_page => 10, :page => params[:page], :include => :message, :order => "messages.created_at DESC" 
  end
    
end
