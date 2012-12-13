require 'spec_helper'

describe Group do

	before :all do
		@group = build(:group)
	end 

	subject { @group }

	it { should belong_to(:user) }
	it { should have_many(:groupings).dependent(:destroy) }
	it { should have_many(:members).through(:groupings).conditions("accepted_at is NOT NULL").dependent(:destroy) }
	it { should have_many(:inverse_groupings).class_name("Grouping").dependent(:destroy) }
 	it { should have_many(:members_pending).through(:inverse_groupings).conditions("groupings.accepted_at" => nil).dependent(:destroy) }
	it { should have_many(:locations).dependent(:destroy) }
  it { should accept_nested_attributes_for(:locations).allow_destroy(true) }
	it { should have_many(:images).dependent(:destroy) }
  it { should accept_nested_attributes_for(:images).allow_destroy(true) }   
	it { should have_many(:item_attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:item_attachments).allow_destroy(true) }
  it { should have_one(:custom).dependent(:destroy) }

	it { should respond_to(:title) }
	it { should respond_to(:description) }
	it { should respond_to(:user_id) }
	it { should respond_to(:slug) }

	describe "validations" do

		it "should be valid" do
			@group.should be_valid
		end
	
		it "has a title" do
			@group.title.length.should be > 0	
		end

		it "should be invalid without a title" do
			@group = build(:group, :title => nil)
			@group.should_not be_valid
		end
	end

	describe "methods" do

		it "should be owned by user" do
			@owner = create(:user)
			@group = build(:group, :user_id => @owner.id)
			@group.owner.should eq(@owner)
		end
	end
	
end
