Then(/^I should have (\d+) groups?$/) do |count|
  Group.count.should == count.to_i 
end