Given /^I have one\s+user "([^\"]*)" with email "([^\"]*)" and password "([^\"]*)"$/ do |login,email, password|
  @user = User.new(:login => login,
                   :email => email, 
                   :password => password, 
                   :confirmed_at => Time.now,
                   :password_confirmation => password).save!

end

Given /^I am an authenticated user$/ do
  login = 'testuser'
  email = 'testing@man.net'
  password = 'secretpass'
  step %{I have one user "#{login}" with email "#{email}" and password "#{password}"}
  
  step("I login with 'testuser' and 'secretpass'")
end

Given /^I am not authenticated$/ do
  visit '/logout'
end

Given /^I login with "(.*?)" and "(.*?)"$/ do |login, password|
  visit '/users/sign_in'
  fill_in "user_username", :with => login
  fill_in "user_password", :with => password
  click_button "Let me in"
end

Then(/^the following count of user "(.*?)" should be (\d+)$/) do |name, count|
  user = User.where(login: name).first
  user.followers(User).size
end

Then(/^the liking count of user "(.*?)" should be (\d+)$/) do |name, count|
  user = User.where(login: name).first
  user.likers(User).size
end