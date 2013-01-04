require 'faker'

FactoryGirl.define do
	factory :item do
		sequence(:id, Random.rand(1000)) { |n| n + Random.rand(1000) }
    title "a testitem"
		description Populator.paragraphs(1..3)
		association :user, factory: :user
		item_type_id [1..6]
		need [true, false]
  end
end
