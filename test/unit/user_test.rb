require 'test_helper'

class UserTest < ActiveSupport::TestCase

	test "should not save user without login" do
		user = User.new
		assert !user.save, "Saved user without login"
	end
end
