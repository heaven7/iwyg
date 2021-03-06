require 'spec_helper'

describe Search do

	describe "for items" do
		
		before :each do 
			@itemsearch = Item.search()
			@item = create(:item, title: "testitem", item_type_id: 1)
			@location = create(:location, city: "Berlin", country: "Deutschland", locatable_id: @item.id, locatable_type: "Item")
		end

		it "should be items, which are searched" do
			@itemsearch.klass.to_s.should == "Item"
		end

		it "should search by title" do 
			@itemsearch = Item.search(:title_cont => "testitem")
			expect(@itemsearch.result.size).to eq(1)
		end
	end
end
