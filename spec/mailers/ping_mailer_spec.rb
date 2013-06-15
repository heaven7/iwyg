require "spec_helper"

describe PingMailer do
  
	describe "defaults" do
		it "should have right defaults" do
			PingMailer.default[:css].should be :mailer
			PingMailer.default[:charset].should eq 'UTF-8'
		end
	end
	
end
