require File.dirname(__FILE__) + '/../../db/seeds.rb'

Given(/^I have a good titled "(.*?)"$/) do |title|
  Item.create!(:title => title, :item_type_id => 1, :need => false)
end

Given(/^I need a good titled "(.*?)"$/) do |title|
  Item.create!(:title => title, :item_type_id => 1, :need => true)
end

Then(/^the following count of item "(.*?)" should be (\d+)$/) do |itemtitle, count|
  item = Item.where(title: itemtitle).first
  item.followers(User).size
end

Then(/^I should have (\d+) items?$/) do |count|
  Item.count.should == count.to_i 
end

