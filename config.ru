# This file is used by Rack-based servers to start the application.
require ::File.expand_path('../config/environment',  __FILE__)
run Iwyg::Application

if ENV["RAILS_ENV"] == "stage"
  RackBaseURI /home/heaven7/rails_apps/iwyg_stage  
  RackEnv production
end
