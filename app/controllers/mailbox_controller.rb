class MailboxController < InheritedResources::Base

  layout 'mailbox'
  helper :users

  before_filter :authenticate_user!
    
  def index
		getMessages
		render :action => "show"
  end

  def show
		getMessages    
	end
    
	private
		
	def getMessages
    @user = current_user
    @folder = @user.inbox
    @messages = @folder.messages.paginate :per_page => 10, :page => params[:page], :include => :message, :order => "messages.created_at DESC" 
	end

end
