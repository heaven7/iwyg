require 'faker'

FactoryGirl.define do
  factory :message do |f|
		f.id Random.rand(100)
    f.to [2,3]
		f.body "the body of the test message"
		f.subject "test message"
  end
end
