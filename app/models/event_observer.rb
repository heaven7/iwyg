class EventObserver < ActiveRecord::Observer
 # observe Event
  
  def after_save(event)

    # proceedEvent(event)

    case event.status.to_i
      when 1 then
        @action = "opened"
      when 2 then
        @action = "accepted"
      when 3 then
        @action = "declined"
      when 4 then
        @action = "closed"   
    end    
    
    @subject = "IWYG EventMailer"
    @title = @resource.title if @resource
   if @action == "opened"
   #     EventMailer.deliver_event_opened(
   #     :resource => @resource,
   #     :receiver => @receiver,
   #     :sender => @sender,
   #     :event => @event,
   #     :receiver_events_url => "#{@host}/users/#{@receiver.id}/events",
   #     :resource_url => "#{@host}/items/#{@resource.id}",
   #     :resource_title => @title,
   #     :subject => @subject
   #   ) 
    else
   #    EventMailer.deliver_event_updated(
   #     :resource => @resource,
   #     :receiver => @receiver,
   #     :sender => @sender,
   #     :action => @action,
   #     :subject => @subject
   #   ) 
    end
   
    
  end
  
  
  private
  
  def proceedEvent(event)
    @host = HOST
    @event = event
    @eventable = @event.eventable_type.to_s
    @resource = @eventable.classify.constantize.find(@event.eventable_id) if @event.eventable_id
    if @resource
      @pinger = @event.ping.owner
      
      case @eventable
        when "User" then
          @id = @resource.id
        else
          @id = @resource.user_id
      end
      @holder = User.find(@id)
      
      if @event.status != 1
        @sender = @pinger
        @receiver = @holder
      else
        @sender = User.find(@event.user_id)
        @receiver = @pinger
      end
    end
  end
  
  def getReceiver(transfer)
    @receiverable = transfer.receiverable_type.to_s
    @receiver = @receiverable.classify.constantize.find(transfer.receiverable_id)
    
  end
end
