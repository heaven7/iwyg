require "spec_helper"

describe MessageMailer do
  
	describe "defaults" do
		it "should have right defaults" do
			MessageMailer.default[:css].should be :mailer
			MessageMailer.default[:charset].should eq 'UTF-8'
		end
	end
	
end
