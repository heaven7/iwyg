Then(/^I should have (\d+) groups?$/) do |count|
  Group.size.should == count.to_i 
end

Then(/^the locations count of group "(.*?)" should be (\d+)$/) do |title, count|
  group = Group.where(title: title).first
  group.locations.size
end