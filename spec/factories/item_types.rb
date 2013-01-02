FactoryGirl.define do
	factory :item_type do
		trait :good do
			id 1
			title "good"
		end
		trait :transport do
			id 2
			title "transport"
		end
		trait :service do
			id 3
			title "service"
		end
		trait :sharingpoint do
			id 4
			title "sharingpoint"
		end
		trait :wisdom do
			id 5
			title "wisdom"
		end
		trait :knowledge do
			id 6
			title "knowledge"
		end
	end
end
