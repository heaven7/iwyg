require "spec_helper"

describe MeetupMailer do
  
	describe "defaults" do
		it "should have right defaults" do
			MeetupMailer.default[:css].should be :mailer
			MeetupMailer.default[:charset].should eq 'UTF-8'
		end
	end
	
end
