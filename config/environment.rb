require 'yaml'
YAML::ENGINE.yamler = 'syck' if defined?(YAML::ENGINE)

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
#Encoding.default_internal = 'UTF-8'
#Encoding.default_external = Encoding::UTF_8

Iwyg::Application.initialize!
#Encoding.default_internal = Encoding::UTF_8
