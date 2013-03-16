require 'yaml'
YAML::ENGINE.yamler = 'psych' if defined?(YAML::ENGINE)

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
#Encoding.default_internal = 'UTF-8'
#Encoding.default_external = Encoding::UTF_8

Iwyg::Application.initialize!
#Encoding.default_internal = Encoding::UTF_8
module Iwyg

  class Application < Rails::Application
    config.generators do |g|
      g.test_framework  :rspec, :fixture_replacement => :factory_girl, :views => true, :helper => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

  end
end

