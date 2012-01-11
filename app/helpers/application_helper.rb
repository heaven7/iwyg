# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end

  # Return a link for use in layout navigation.
  def nav_link(text, controller, action="index")
    link_to_unless_current text, :controller => controller, :action => action
  end

  # Description helper 
  def shorten (string, count = 100)
  	if string.length >= count 
  		shortened = string[0, count]
  		splitted = shortened.split(/\s/)
  		words = splitted.length
  		splitted[0, words-1].join(" ") + '...'
  	else 
  		string
  	end
  end
  
  # Add and remove fields
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + link_to_function(name, 'if (confirm("Do you really want to remove this?")) remove_fields(this)', :class => "field-remove")
  end
  
  def link_to_add_fields(name, f, association)  
    new_object = f.object.class.reflect_on_association(association).klass.new  
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render("share/" + association.to_s.singularize + "_fields", :f => builder)
    end  
    link_to_function(name, ("add_fields(this, '#{association}', '#{escape_javascript(fields)}')"), :class => "field-add" )  
  end    
  
  # replacement for the former restful_authentication plugin
  def logged_in?
    user_signed_in?
  end
  
  # language switch
  def locale_url(url, locale)   
    if url == "/"
      url = "#{locale}"
    else
      url.gsub("/#{I18n.locale}", "/#{locale}")
    end
  end

  
  # nested layouts
  def parent_layout(layout)
    @_content_for[:layout] = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end  

  def transferable_url
    transferable = controller.controller_name.singularize
    transferable_path(:transferable_type => transferable, :transferable_id => controller.instance_variable_get("@#{transferable}").id)
  end
  
  def users_browser
    user_agent =  request.env['HTTP_USER_AGENT'].downcase 
    @users_browser ||= begin
      if user_agent.index('msie') && !user_agent.index('opera') && !user_agent.index('webtv')
          'ie'+user_agent[user_agent.index('msie')+5].chr
      elsif user_agent.index('gecko/')
          'gecko'
      elsif user_agent.index('opera')
          'opera'
      elsif user_agent.index('konqueror')
          'konqueror'
      elsif user_agent.index('ipod')
          'ipod'
      elsif user_agent.index('ipad')
          'ipad'
      elsif user_agent.index('iphone')
          'iphone'
      elsif user_agent.index('chrome/')
          'chrome'
      elsif user_agent.index('applewebkit/')
          'safari'
      elsif user_agent.index('googlebot/')
          'googlebot'
      elsif user_agent.index('msnbot')
          'msnbot'
      elsif user_agent.index('yahoo! slurp')
          'yahoobot'
      #Everything thinks it's mozilla, so this goes last
      elsif user_agent.index('mozilla/')
          'gecko'
      else
          'unknown'
      end
    end
    return @users_browser
  end
   
end
