Feature: Pings
  In Order to implement pings
  As a logged in user
  I want to ping items, let users accept or decline pings

  Background:
	Given my locale is ":en"
	And I have one user "user1" with email "user1@test.net" and password "secretpass"
    And I have one user "user2" with email "user2@test.net" and password "secretpass"
    And I login with "user1" and "secretpass"
	And I am on resources
	And I follow "New resource"
	And I select "Good" from "a" 
	And I fill in "Title" with "My first item"
	And I press "Save"
	And I am not authenticated

  @javascript
  Scenario: Make a ping on a item
    Given I login with "user2" and "secretpass"
    And I see the item titled "My first item"
    And I fill in "ping_body" with "testping"
    And I press "I need it"
    Then I should see "Ping was successfully sent."
    And the pings count of item "My first item" should be 1