require 'spec_helper'

describe "actions/new" do
  before(:each) do
    assign(:action, stub_model(Action,
      :watchable_id => 1,
      :watchable_type => "MyString",
      :type => "MyString",
      :user_id => 1
    ).as_new_record)
  end

  it "renders new action form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => actions_path, :method => "post" do
      assert_select "input#action_watchable_id", :name => "action[watchable_id]"
      assert_select "input#action_watchable_type", :name => "action[watchable_type]"
      assert_select "input#action_type", :name => "action[type]"
      assert_select "input#action_user_id", :name => "action[user_id]"
    end
  end
end
