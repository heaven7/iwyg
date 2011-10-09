module SearchesHelper
  
  def search_count(keyword)
    Search.count(:all, :conditions => {:keyword => keyword})
  end
  
end
