require 'spec_helper'

describe "actions/edit" do
  before(:each) do
    @action = assign(:action, stub_model(Action,
      :watchable_id => 1,
      :watchable_type => "MyString",
      :type => "MyString",
      :user_id => 1
    ))
  end

  it "renders the edit action form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => actions_path(@action), :method => "post" do
      assert_select "input#action_watchable_id", :name => "action[watchable_id]"
      assert_select "input#action_watchable_type", :name => "action[watchable_type]"
      assert_select "input#action_type", :name => "action[type]"
      assert_select "input#action_user_id", :name => "action[user_id]"
    end
  end
end
