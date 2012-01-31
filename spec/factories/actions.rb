# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :action do
    watchable_id 1
    watchable_type "MyString"
    type "MyString"
    user_id 1
  end
end
