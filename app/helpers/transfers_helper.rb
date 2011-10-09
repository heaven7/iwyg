module TransfersHelper

  def item(id)
    Item.find(id)
  end
  
  def user(id)
    User.find(id)
  end
  
  def status(id)
    Status.find(id)
  end
  
  def options
    options = Hash.new
    options = 
    [
      ["I bring the item to a local SharingPoint", 1], 
      ["I ask my friends for transportation", 2],
      ["#{@pinger.login} has to get it on his own", 3], 
      ["I transport/send it by my own", 4], 
      ["I don't know yet", 5]
    ]
  end
  
end
