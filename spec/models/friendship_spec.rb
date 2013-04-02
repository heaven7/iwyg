require 'spec_helper'

describe Friendship do
	
	before :all do
		@invitation = create(:invitation)
		@friendship = build(:friendship, invitation: @invitation)
	end 

	subject { @friendship }

	it { should belong_to(:invitation).class_name('Invitation') }
	it { should belong_to(:friend).class_name('User') }
	it { should belong_to(:user) }



end
