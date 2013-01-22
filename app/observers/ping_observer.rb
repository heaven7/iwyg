class PingObserver < ActiveRecord::Observer
  observe Ping
  
  def after_create(ping)

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

      PingMailer.ping_opened(@resource, @user, @holder, @message, @ping).deliver
      
    else
      if @resource.class.to_s == "User"
        @title = @resource.login
      else
        @title = @resource.title
      end
      @message = I18n.translate("#{@notifyOn}.#{@action}",
        :resource_title => @title,
        :user => @user
      )

      PingMailer.ping_updated(@resource, @user, @holder, @action, @message, @ping).deliver
      
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
    when "Group" then
      @id = @resource.user_id
      @notifyOn = "ping.notifyOn.group"
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
