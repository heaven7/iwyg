class MessagesController < InheritedResources::Base

  layout 'mailbox'
	impressionist :actions => [:show]
	respond_to :html, :js
	before_filter :updateNotifications, :only => [:show]
  before_filter :authenticate_user!

  def show
    @user = current_user
    @message = @user.received_messages.find(params[:id])
		@author = @message.author.login
    @message.update_attributes(:read => true) if @message.read.blank?
  end
  
  def reply
    @user = current_user
    @original = @user.received_messages.find(params[:id])
    @message = @user.sent_messages.build(:to => @original.author.login, :subject => params[:message][:subject], :body => params[:message][:body] )
		if @message.save
			@subject = "mailer.message.userHasRepliedMessage"
			MessageMailer.delay.hasRepliedMessage(@message, params[:locale], @subject)
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
		end  
  end
  
  def forward
    @original = current_user.received_messages.find(params[:id])
    
    subject = @original.subject.sub(/^(Fwd: )?/, "Fwd: ")
    body = @original.body.gsub(/^/, "> ")
    @message = current_user.sent_messages.build(:subject => subject, :body => body)
    render :template => "sent/new"
  end
  
  def destroy
    @message = current_user.received_messages.find(params[:id])
    @message.custom.update_attributes(:deleted => true)
    redirect_to :controller => "mailbox"
    flash[:notice] = t("flash.mailbox.delete.notice")
  end
  
  def undelete
    @message = current_user.received_messages.find(params[:id])
    @message.custom.update_attributes(:deleted => false)
    redirect_to :controller => "mailbox"
    flash[:notice] = t("flash.mailbox.restore.notice") 
  end
end
