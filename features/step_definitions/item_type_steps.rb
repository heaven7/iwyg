Given(/^I have a item of type "(.*?)"$/) do |type|
  t = ItemType.find_by_title(type)
  @i = Item.create(title: "test", item_type_id: t.id )
end

Then(/^the itemtype should be (\d+)$/) do |id|
  @i.item_type_id.should == id.to_i
end