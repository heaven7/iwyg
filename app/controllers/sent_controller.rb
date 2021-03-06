class SentController < InheritedResources::Base
  respond_to :html , :js
  
  layout 'mailbox'
	before_filter :updateNotifications, :only => [:show]
  before_filter :authenticate_user!

  def index
    @messages = current_user.sent_messages.paginate :per_page => 10, :page => params[:page], :order => "created_at DESC"
  end

  def show
    @message = current_user.sent_messages.find(params[:id])
    @message.toggle!(:read) if @message.read.blank? 
		impressionist(@message)
  end

  def new
    @message = current_user.sent_messages.build
    respond_to do |format|
      format.html
      format.js do
        render :layout => false
      end
    end
  end
  
  def create
    @message = current_user.sent_messages.build(params[:message])
    @id = params[:message][:to] || params[:message][:id]
    @message.custom = Custom.new
    if @message.valid?
      respond_to do |format|
        if @message.save
					@subject = "mailer.message.userHasSendMessage"
					MessageMailer.delay.hasSendMessage(@message, params[:locale], @subject)
					@message.recipients.each do |receiver|
						@mid = @message.id.to_i - 1
						Notification.new(
							 :sender => @message.author, 
							 :receiver => receiver, 
							 :notifiable_id => @mid, 
							 :notifiable_type => "Message",
							 :title => @subject
						).save!			
					end          
					format.js { render :layout => false }
        else
          format.html { redirect_to new_user_message_path(:current) }
					format.js  { render :layout => false }
        end
      end
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @message = current_user.sent_messages.find(params[:id])
    @message.custom.update_attributes(:deleted => true)
    redirect_to :action => "index"
    flash[:notice] = "Message deleted."
  end
  
  def undelete
    @message = current_user.sent_messages.find(params[:id])
    @message.custom.update_attributes(:deleted => false)
    redirect_to :action => "index"
    flash[:notice] = "Message restored."
  end
end
