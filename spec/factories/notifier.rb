require 'faker'

FactoryGirl.define do
  factory :notifier do |f|
		f.user_id Random.rand(100)
		f.notifyable_id Random.rand(100)
		f.notifyable_type "User"
  end
end
