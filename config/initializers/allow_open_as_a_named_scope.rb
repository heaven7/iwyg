require 'active_record'
class ActiveRecord::Base
  class << self
    alias :_open :open
    undef_method :open
  end
end
