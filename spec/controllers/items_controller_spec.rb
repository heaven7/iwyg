require "spec_helper"
include Warden::Test::Helpers 

describe ItemsController do
	
	describe "routing" do
		before :each do 
			@routes = Rails.application.routes
		end

		it "routes to index" do
			r = @routes.recognize_path("/items")
			r[:action].should eq("index")
		end

		it "routes to show" do
			r = @routes.recognize_path("/items/testitem")
			r[:action].should eq("show")
		end

		it "routes to new" do
			r = @routes.recognize_path("/items/new")
			r[:action].should eq("new")
		end

	end
end
