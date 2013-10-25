module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      root_path
    when /logout/
      '/logout'
    when /the list of items/
    when /resources/
      items_path
    when /register/
      new_user_registration_path   
    else
      raise "Can't find mapping from \"#{page_name}\" to a path."
    end
  end
end

World(NavigationHelpers)
