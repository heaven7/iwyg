require File.dirname(__FILE__) + '/../../lib/auto_complete/auto_complete.rb'
require File.dirname(__FILE__) + '/../../lib/auto_complete/auto_complete_macros_helper.rb'

ActionController::Base.send :include, AutoComplete
ActionController::Base.helper AutoCompleteMacrosHelper