require "spec_helper"
include Warden::Test::Helpers 


# how to test methods in application controller??
def searchByRangeIn(model, params)
	if params[:near]
		@location_city = (request.location.city.blank?) ? params[:near] : request.location.city 
		if not params[:within].blank? && params[:within].to_i > 0
			@radius = params[:within]
		else
			@radius = 200
		end			
		@locations = Location.where(locatable_type: model).near(@location_city, @radius, :order => "distance")
  	if @locations 
			@ids = []			
			@locations.each do |l|
				@ids << l.locatable_id.to_i
			end		
			return model.classify.constantize.where(:id => @ids).order("field(#{model.downcase.pluralize}.id, #{@ids.join(',')})") if @ids.size > 0
			return model.classify.constantize.where(:id => @ids)			
		end
  end
end

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

	describe "searching" do		
		before :each do 
			@item = create(:item, title: "testitem", item_type_id: 1)
			@location = create(:location, city: "Berlin", country: "Deutschland", locatable_id: @item.id, locatable_type: "Item")
		end

		it "should search by location" do 
			@params = Hash.new(:near => "Berlin, Deutschland", :within => 2000)
			@itemsearch = searchByRangeIn("Item", @params)
#			expect(@itemsearch.size).to eq(1)
		end

	end
end
