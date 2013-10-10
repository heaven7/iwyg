
module UsersHelper
  
  def microThumb(user)
    getUserImage(user, "micro")
  end
  
  def tinyThumb(user)
    getUserImage(user, "tiny")
  end
  
  def smallThumb(user)
    getUserImage(user, "small")
  end
  
  def bigThumb(user)
    getUserImage(user, "big")
  end
  
	def auditText(audit)
		case audit.auditable_type.to_s

      when "Item"
        item = Item.with_deleted.where(:id => audit.auditable_id).first
				if not item.deleted?        
					case audit.action
		      when "create"
		        if item.need?
		          link_to(t("hasCreatedANeed", :title => item.title).html_safe, item)
		        else
		          link_to(t("hasCreatedAnOffer", :title => item.title).html_safe, item)
		        end
		      when "update"
		      #  link_to(t("hasUpdatedAnItem", :title => item.title).html_safe, item)
		      end
				end

      when "Userdetails"
        case audit.action
        when "create"
          t("hasJoinedTheCommunity").html_safe
        when "update"
        #  t("hasUpdatedtheUserdetails").html_safe
        end
      when "Group"
        group = Group.with_deleted.where(:id => audit.auditable_id).first
				if not group.deleted?        
					case audit.action
		      when "create"
		        link_to(t("hasCreatedAGroup", :title => group.title).html_safe, group)
		      when "update"
		        #link_to(t("hasUpdatedAGroup", :title => group.title).html_safe, group)
		      end
				end

      when "Location"
        #location = Location.with_deleted.where(:id => audit.auditable_id).first
        #resource = location.locatable_type.constantize.find(location.locatable_id)
        #case audit.action
        #when "create"
        #  link_to(t("hasCreatedALocation", :title => resource.title).html_safe, resource)
        #when "update"
        #  link_to(t("hasUpdatedALocation", :title => resource.title).html_safe, resource)
        #end

      when "Ping"
        ping = Ping.with_deleted.where(:id => audit.auditable_id).first
        resource = ping.pingable_type.constantize.with_deleted.find(ping.pingable_id) if ping.pingable_type && ping.pingable_type.to_s == "Item"
				if resource.deleted? == false  
					case audit.action
		      when "create"
		        link_to(t("hasPingedOn", :title => resource.title).html_safe, ping)
		      when "update"
		        case ping.statusTitle
		        when "accepted"
		          link_to(t("usersPingIsAccepted", :title => resource.title).html_safe, ping)
		        when "declined"
		          link_to(t("usersPingIsDeclined", :title => resource.title).html_safe, ping)
		        when "closed"
		          link_to(t("usersPingIsClosed", :title => resource.title).html_safe, ping)
		        end
		      end
				end

      when "Meetup"
        meetup = Meetup.with_deleted.where(:id => audit.auditable_id).first
				if not meetup.deleted?        
					case audit.action
		      when "create"
		        link_to(t("hasCreatedAMeetup", :title => meetup.title).html_safe, meetup)
		      when "update"
		      #  link_to(t("hasUpdatedAMeetup", :title => meetup.title).html_safe, meetup)
		      when "destroy"
		      #  link_to(t("hasDestroyedAMeetup", :title => meetup.title).html_safe, meetup)
		      end
				end
      when "Comment"
        comment = Comment.with_deleted.where(:id => audit.auditable_id).first
        resource = comment.commentable
        case audit.action
        when "create"
					case resource.class
					when "Item"
						link_to(t("hasCommentedOn", :title => resource.title), resource)
					when "Ping"
						link_to(t("hasCommentedOn", :title => resource.body), resource)
					when "Group"
           #link_to(t("hasCommentedOn", :title => resource.title), resource)
					end
        end
      else
		nil
      end
	end
  
  def is_active?(page_name)
    "ui-corner-all"
    "active" if params[:action] == page_name
  end
  
  private
  
  def getUserImage(user, size)
    if user && user.images.first
    	user.images.first.image.url(size)
    else
		counter = user.id.to_i % 6
    	"global/avatar_dummy_#{size}_#{counter}.png"
    end
  end
  
end
