class TransferObserver < ActiveRecord::Observer
  observe Transfer
  
  def after_save(transfer)

    proceedTransfer(transfer)

    case transfer.status.to_i
      when 1 then
        @action = "opened"
      when 2 then
        @action = "accepted"
      when 3 then
        @action = "declined"
      when 4 then
        @action = "closed"   
    end    
    
    @subject = "IWYG TransferMailer"
    if @action == "opened"
       TransferMailer.deliver_transfer_opened(
        :resource => @resource,
        :receiver => @receiver,
        :transfer => @transfer,
        :transferer => @transferer,
        :transferer_url => "#{@host}/users/#{@user.id}",
        :receiver_transfers_url => "#{@host}/users/#{@receiver.id}/transfers",
        :accept_url => "#{@host}/transfers/#{@transfer.id}/accept/", 
        :transfer_url => "#{@host}/transfers/#{@transfer.id}/", 
        :resource_url => "#{@host}/items/#{@resource.id}",
        :decline_url => "#{@host}/transfers/#{@transfer.id}/decline/",
        :subject => @subject
      ) 
    else
       TransferMailer.deliver_transfer_updated(
        :resource => @resource,
        :user => @user,
        :holder => @holder,
        :action => @action,
        :transferer => @transferer,
        :user_url => "#{@host}/users/#{@user.id}",
        :holder_transfers_url => "#{@host}/users/#{@holder.id}/transfers",
        :transfer_url => "#{@host}/transfers/#{@transfer.id}/", 
        :resource_url => "#{@host}/items/#{@resource.id}",
        :subject => @subject
      ) 
    end
   
    
  end
  
  
  private
  
  def proceedTransfer(transfer)
    @host = HOST
    @transfer = transfer
    @receiver = User.find(@transfer.pinger)
    @transferable = @transfer.transferable_type.to_s
    @resource = @transferable.classify.constantize.find(@transfer.transferable_id)
    @user = User.find(@transfer.user_id)
    case @transferable
      when "User" then
        @id = @resource.id
      else
        @id = @resource.user_id
    end
    @holder = User.find(@id)
    
    if @transfer.status != 1
      @transferer = @holder
    else
      @transferer = @user
    end
    
  end
  
  def getReceiver(transfer)
    @receiverable = transfer.receiverable_type.to_s
    @receiver = @receiverable.classify.constantize.find(transfer.receiverable_id)
    
  end
end
