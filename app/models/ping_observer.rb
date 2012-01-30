class PingObserver < ActiveRecord::Observer
  observe Ping
  
  def after_save(ping)

    proceedPing(ping)
     
    case ping.status.to_i
      when 1 then
        @action = "opened"
      when 2 then
        @action = "accepted"
      when 3 then
        @action = "declined"
      when 4 then
        @action = "closed"   
    end 
       
    @subject = "IWYG PingMailer"
    
    if @action == "opened"
       if @resource.class.to_s == "User"
         @title = @resource.login
       else
         @title = @resource.title
       end
       @message = I18n.translate("#{@notifyOn}.#{@action}", 
              :resource_title => @title,
              :pinger => @pinger.login
       )
              
       PingMailer.deliver_ping_opened(
        :resource => @resource,
        :user => @user,
        :holder => @holder,
        :user_url => "#{@host}/users/#{@user.id}",
        :holder_pings_url => "#{@host}/users/#{@holder.id}/pings",
        :accept_url => "#{@host}/pings/#{@ping.id}/accept/", 
        :ping_url => "#{@host}/pings/#{@ping.id}/", 
        :resource_url => "#{@host}/items/#{@resource.id}",
        :decline_url => "#{@host}/pings/#{@ping.id}/decline/",
        :subject => @subject,
        :message => @message
      ) 
      
    else
    
       @message = I18n.translate("#{@notifyOn}.#{@action}", 
              :resource_title => @resource.title,
              :user => @user
       )
       
       PingMailer.deliver_ping_updated(
        :resource => @resource,
        :user => @user,
        :holder => @holder,
        :action => @action,
        :user_url => "#{@host}/users/#{@user.id}",
        :holder_pings_url => "#{@host}/users/#{@holder.id}/pings",
        :ping_url => "#{@host}/pings/#{@ping.id}/", 
        :resource_url => "#{@host}/items/#{@resource.id}",
        :subject => @subject,
        :message => @message
      ) 
      
    end
   
  end
  
  
  private
  
  def proceedPing(ping)
    @host = HOST
    @ping = ping
    @pingable = @ping.pingable_type.to_s
    @resource = @pingable.classify.constantize.find(@ping.pingable_id)
    @user = User.find(@ping.user_id)
    case @pingable
      when "User" then
        @id = @resource.id
        @notifyOn = "ping.notifyOn.user"
      when "Transfer" then
        @id = @resource.user_id
        @resource = Item.find(@resource.transferable_id)
        @notifyOn = "ping.notifyOn.transfer"
      when "Item" then
        @itemType = ItemType.find(@resource.item_type_id.to_i).title.downcase
        @id = @resource.user_id   
        @notifyOn = "ping.notifyOn.item.#{@itemType}"
    end
    @holder = User.find(@id) 
    
    if @ping.status != 1
      @pinger = @holder
    else
      @pinger = @user
    end
    
  end
end
