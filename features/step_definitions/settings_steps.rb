Then(/^this "(.*?)" with title "(.*?)" should have a setting "(.*?)" with value "(.*?)"$/) do |object, title, settingname, settingvalue|
  object = object.classify.constantize.find_by_title(title)
  eval("object.settings.#{settingname}.should == settingvalue.to_s")
end
