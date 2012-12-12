require 'faker'
require 'populator'

FactoryGirl.define do
  factory :group do |f|
#		@user = Factory.create(:user)
		f.id (1 + Random.rand(1000))
    f.title "a Testgroup"
		f.description Populator.paragraphs(1..3)
		f.user_id @user
		f.slug "a-testgroup"
  end
end
