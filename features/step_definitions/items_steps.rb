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

Then(/^the pings count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.pings.size
end

Then(/^the following count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.followers(User).size
end

Then(/^the liking count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.likers(User).size
end

Then(/^the locations count of item "(.*?)" should be (\d+)$/) do |title, count|
  item = Item.where(title: title).first
  item.locations.size
end

Then(/^I should have (\d+) items?$/) do |count|
  Item.count.should == count.to_i 
end

