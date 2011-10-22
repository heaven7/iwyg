module PingsHelper
  
  def statusTitle(ping)
    Status.find(ping.status).title.to_s
  end
  
  def pingStatus(ping)
    @ping = Ping.find(ping.id)
    @ping.status.to_i
  end
    
  def is_accepted?(ping)
    if pingStatus(ping) == 2
      true
    else
      false
    end
  end
  
  def is_open?(ping)
    if pingStatus(ping) == 1
      true
    else
      false
    end
  end
  
  def is_closed?(ping)
    if pingStatus(ping) == 4
      true
    else
      false
    end
  end
  
  def pingerOf(ping)
    User.find(ping.user_id)
  end
  
  def itemOf(ping)
    @item = Item.find(ping.pingable_id)
  end
  
  
  def itemTypeOfPing(item)
    ItemType.find(item.item_type_id).title
  end
  
  def transferOf(ping)
    @item = Item.find(ping.pingable_id)
    Transfer.find_by_transferable_id(@item.id)
  end
  
  
  def holder?(id, type)
    @resource = find_resource(id, type)
    
    if type == "User"
      @id = @resource.id
    else
      @id = @resource.user_id
    end 
    
    if User.find(@id) == current_user
      true
    else
      false
    end
  end
  
  
  def find_resource(id, type)
    type.classify.constantize.find(id)
  end
  
  def find_pingedTitle(pingable, id)
    case pingable
    when "User"
      User.find(id).login    
    else 
      pingable.classify.constantize.find(id).title
    end
  end
  
  def pingedTitle(ping)
    case ping.pingable_type
    when "User"
      title = User.find(ping.pingable_id).login
    when "Transfer"
      transfer = Transfer.find(ping.pingable_id)
      title = Item.find(transfer.transferable_id).title
    when "Item" 
      title = ping.pingable_type.classify.constantize.find(ping.pingable_id).title
    end
    "#{ping.pingable_type}: #{title}"
  end
  
  def pingoptions(ping)
    if ping.pingable_type == "Item"
      item = Item.find(ping.pingable_id)
      
      case ping.statusTitle.to_s
      
      when "opened"
        
        if item.owner == current_user
          link_to t("ping.accept"), accept_ping_path(ping), :method => :put 
        end
        
      when "accepted"
        
        if item.owner == current_user
          if item.need?
            
            case item.itemtype.downcase.to_s
            when "good"
              link_to t("ping.setTransfer"), new_polymorphic_path([current_user, Transfer.new], 
                :pinger => current_user, 
                :transferable_type => ping.pingable_type, 
                :transferable_id => ping.pingable_id)  if item.multiple or !Transfer.exists?
            else
              link_to t("ping.setMeetup"), new_polymorphic_path([current_user, Meetup.new], 
                "event[ping]" => ping.id, 
                "event[eventable_type]" => ping.pingable_type, 
                "event[eventable_id]" => ping.pingable_id) if item.multiple or !Meetup.exists?
            end
            
          else # !item.need? of owner
            
            case item.itemtype.downcase.to_s
            when "good"
              link_to t("ping.setTransfer"), new_polymorphic_path([current_user, Transfer.new], 
                :pinger => ping.user_id, 
                :transferable_type => ping.pingable_type, 
                :transferable_id => ping.pingable_id) if item.multiple or !Transfer.exists? 
            else
              link_to t("ping.setMeetup"), new_polymorphic_path([current_user, Meetup.new], 
                "event[ping]" => ping.id, 
                "event[eventable_type]" => ping.pingable_type, 
                "event[eventable_id]" => ping.pingable_id) if item.multiple or !Meetup.exists?
            end
            
          end         
        else # item.owner != current_user
        
          if item.need?
          else
          end
      
        end
        
      when "declined"
      
      when "closed"
      
      end
    end
  end
end