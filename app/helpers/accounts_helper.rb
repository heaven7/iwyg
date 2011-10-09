module AccountsHelper

  def has_taken?(t)
    if t == true
     "has taken"
    else
     "has given"
    end
  end
  
end
