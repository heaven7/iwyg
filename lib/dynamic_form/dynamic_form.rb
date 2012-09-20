require File.dirname(__FILE__) + '/action_view/helpers/dynamic_form.rb'

class ActionView::Base
  include DynamicForm
end
