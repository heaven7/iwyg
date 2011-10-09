class CommentObserver < ActiveRecord::Observer
  observe Comment
  
  def after_save(comment)
    # give notification to user or itemowner
    @host = HOST
    @commenter = User.find(comment.user_id)
    case comment.commentable_type
    when "Item"
      @resource = Item.find(comment.commentable_id)
      @subject = @commenter.login + " has commented your: " + @resource.title + "."
      @title = @resource.title
      @resource_url = "#{@host}/items/#{@resource.id}"
    when "Ping"
      @ping = Ping.find(comment.commentable_id)
      @resource = Item.find(@ping.pingable_id)
      @subject = @commenter.login + " has commented the Ping of your: " + @resource.title + "."
      @title = "Ping of: " + @resource.title
      @resource_url = "#{@host}/pings/#{@ping.id}"
      @resource = @ping
    when "Transfer"
      @transfer = Transfer.find(comment.commentable_id)
      @resource = Item.find(@transfer.transferable_id)
      @subject = @commenter.login + " has commented the Transfer of your: " + @resource.title + "."
      @title = "Transfer of: " + @resource.title
      @resource_url = "#{@host}/transfers/#{@transfer.id}"
    when "User"
      @resource = User.find(comment.commentable_id)
      @subject = @commenter.login + " has commented you."
      @title = @resource.title
      @resource_url = "#{@host}/users/#{@resource.id}"
    end
    
    @owner = User.find(@resource.user_id)
    
    UserMailer.deliver_comment(
      :resource => @resource,
      :resource_url => @resource_url,
      :title => @title,
      :comment => comment,
      :commenter => @commenter,
      :commenter_url => "#{@host}/users/#{@commenter.id}",
      :owner   => @owner,      
      :subject => @subject
    ) 
  end
end
