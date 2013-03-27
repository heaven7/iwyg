# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    sender_id 1
    username "MyString"
    password "MyString"
    emails "MyText"
    invitationmessage "MyText"
  end
end
