Then(/^I should have (\d+) group?$/) do |count|
  Group.all.size.should == count.to_i 
end

Then(/^the locations count of group "(.*?)" should be (\d+)$/) do |title, count|
  group = Group.where(title: title).first
  group.locations.size
end

Then(/^the count of groups visible for all should be (\d+)$/) do |count|
  Group.with_settings_for('visible_for').visible_for_all.size
end
