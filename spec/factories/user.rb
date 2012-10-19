require 'faker'

FactoryGirl.define do
  factory :user do |f|
		f.id Random.rand(100)
    f.login Faker::Internet.user_name
		f.password "password"
		f.password_confirmation "password"
		f.email Faker::Internet.email
  end
end
