module ImagesHelper

  def get_session_key 
    ActionController::Base.session_options[:key]
  end
  
  def get_session_secret 
    ActionController::Base.session_options[:secret]
  end
end
