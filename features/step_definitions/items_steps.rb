require File.dirname(__FILE__) + '/../../db/seeds.rb'

Given(/^I have a good titled "(.*?)"$/) do |title|
  Item.create!(:title => title, :item_type_id => 1, :need => false)
end

Given(/^I need a good titled "(.*?)"$/) do |title|
  Item.create!(:title => title, :item_type_id => 1, :need => true)
end

Given(/^I see the item titled "(.+)"$/) do |title|
  item = Item.where(title: title).first
  visit item_path(item.id)
end

Given(/^I create an item with "(.+)"$/) do |args|
  Item.create!(args)
end

Given(/^I tag the item "(.+)" with "(.+)"$/) do |title, tag|
  item = Item.where(title: title).first
  item.tag_list.add(tag)
  item.save!
end

Given(/^I set the visibility of item "(.*?)" to "(.*?)"$/) do |title, value|
  item = Item.where(title: title).first
  item.settings.visible_for = value
  item.save!
end

Given(/^I add to item "(.+)" the location "(.+)"$/) do |title, address|
  item = Item.where(title: title).first
  item.locations.build(address: address)
  item.save!
end

# countings

Then(/^the pings count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.pings.size.should == count.to_i  
end

Then(/^the following count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.followers(User).size.should == count.to_i 
end

Then(/^the liking count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.likers(User).size.should == count.to_i 
end

Then(/^the locations count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.locations.size.should == count.to_i 
end

# settings

Then(/^the count of items visible for all should be (\d+)$/) do |count|
  Item.with_settings_for('visible_for').visible_for_all.size.should == count.to_i
end

Then(/^I should have (\d+) items?$/) do |count|
  Item.all.size.should == count.to_i 
end

