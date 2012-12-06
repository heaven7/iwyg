require 'faker'

FactoryGirl.define do
  factory :user do |f|
		f.id (1 + Random.rand(1000))
    f.login Faker::Internet.user_name
		f.password "password"
		f.password_confirmation "password"
		f.email Faker::Internet.email
		f.confirmed_at Time.now
  end
end
