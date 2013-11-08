Then(/^the locations count of group "(.*?)" should be (\d+)$/) do |title, count|
  group = Group.where(title: title).first
  group.locations.size
end

