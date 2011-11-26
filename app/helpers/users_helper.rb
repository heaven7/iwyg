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
  

  
  def is_active?(page_name)
    "ui-corner-all"
    "active" if params[:action] == page_name
  end
  
  private
  
  def getUserImage(user, size)
    if user && user.images.first
      user.images.first.image.url(size)
    else
      "global/avatar_dummy_#{size}.png"
    end
  end
  
end