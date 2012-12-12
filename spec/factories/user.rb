require 'faker'


FactoryGirl.define do
	sequence(:login) { |n| Faker::Name.first_name + n.to_s }

	factory :user do
		sequence(:id, Random.rand(1000)) { |n| n + Random.rand(1000) }
    login
		password "password"
		password_confirmation "password"
		sequence(:email, Random.rand(1000)) {|n| "email_#{n}@test.com" }
		confirmed_at Time.now
  end
end
