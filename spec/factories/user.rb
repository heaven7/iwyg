require 'faker'


FactoryGirl.define do
	sequence(:id) { |n| n + Random.rand(1000) }
	sequence(:email) { |n| "email_#{n}@factory.com" }
	sequence(:login) { |n| Faker::Name.first_name + n.to_s }

	factory :user do
		sequence(:id, Random.rand(1000)) { |n| n + Random.rand(1000) }
#		sequence(:id) {|n| n + Random.rand(1000) }
    login
#		sequence(:login) {|n| Faker::Name.first_name + n.to_s }
		password "password"
		password_confirmation "password"
#		email { generate(:email) }
		sequence(:email, Random.rand(1000)) {|n| "email_#{n}@test.com" }
		confirmed_at Time.now
  end
end
