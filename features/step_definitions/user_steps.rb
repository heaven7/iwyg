Given /^I have one\s+user "([^\"]*)" with email "([^\"]*)" and password "([^\"]*)"$/ do |login,email, password|
  @user = User.new(:login => login,
                   :email => email, 
                   :password => password, 
                   :password_confirmation => password).save!

end

Given /^I am an authenticated user$/ do
  login = 'testuser'
  email = 'testing@man.net'
  password = 'secretpass'
  step %{I have one user "#{login}" with email "#{email}" and password "#{password}"}
  
  visit '/users/sign_in'
  fill_in "user_username", :with => email
  fill_in "user_password", :with => password
  click_button "Let me in"
end

Given /^I am not authenticated$/ do
  visit destroy_user_session_path
end
