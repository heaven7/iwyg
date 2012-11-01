class MessagesController < InheritedResources::Base

  layout 'mailbox'

  def show
    @user = current_user
    @message = @user.received_messages.find(params[:id])
		#@message = Message.find(@message_copy.message.id)
    @message.update_attributes(:read => true) if @message.read.blank?
  end
  
  def reply
    @user = current_user
    @original = @user.received_messages.find(params[:id])
    
    @message = @user.sent_messages.build(:to => [@original.author.id], :subject => @original.subject, :body => @original.body)
    render :template => "sent/nojsform"
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
