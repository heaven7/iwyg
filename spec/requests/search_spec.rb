require "spec_helper"
include Warden::Test::Helpers 

describe Search do

	it "GET items search" do
		visit search_items_path
		page.should have_content("0 Resources found")
#		save_and_open_page
	end

end
