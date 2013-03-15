if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    Sidekiq.configure_client do |config|
      config.redis = { :size => 1 }
    end if forked
  end
end

# Patch Sidekiq to allow usage of #delay proxy in 1.9.2.
#module Sidekiq
#  module Extensions
#    class Proxy < (RUBY_VERSION < '1.9' ? Object : BasicObject)
#      def initialize(performable, target, options={})
#        @performable = performable
#        @target = target.to_s
#        @opts = options
#      end
#    end
#
#    class DelayedMailer
#      def perform(yml)
#        (target, method_name, args) = YAML.load(yml)
#        target.to_const.send(method_name, *args).deliver
#      end
#    end
#
#    class DelayedModel
#      def perform(yml)
#        (target, method_name, args) = YAML.load(yml)
#        target.to_const.send(method_name, *args)
#      end
#    end
#  end
#end

class ActiveRecord::Base
  yaml_as "tag:ruby.yaml.org,2002:ActiveRecord"
 
  def self.yaml_new(klass, tag, val)
    klass.unscoped.find(val['attributes'][klass.primary_key])
  end
 
  def to_yaml_properties
    ['@attributes']
  end
end
