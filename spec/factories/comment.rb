require 'populator'

FactoryGirl.define do
	factory :comment do
		body Populator.paragraphs(1)

		trait :on_items do
			after_build do |c|
				c.commentable = Factory.build(:item)
			end
		end
	end
end
