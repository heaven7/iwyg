require "spec_helper"
include Warden::Test::Helpers 

describe ItemsController do
	

	it "renders the index template" do
    get :index
    response.body.should eq ""
    response.should render_template("index")
  end

end
