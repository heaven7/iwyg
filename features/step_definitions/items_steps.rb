Given(/^I have a good titled "(.*?)"$/) do |title|
  Item.create!(:title => title, :item_type_id => 1, :need => false)
end

Given(/^I need a good titled "(.*?)"$/) do |title|
  Item.create!(:title => title, :item_type_id => 1, :need => true)
end

