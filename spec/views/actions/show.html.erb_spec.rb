require 'spec_helper'

describe "actions/show" do
  before(:each) do
    @action = assign(:action, stub_model(Action,
      :watchable_id => 1,
      :watchable_type => "Watchable Type",
      :type => "Type",
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Watchable Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Type/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
