Feature: Locations
  In Order to integrate locations
  I want to show maps and let users manage their locations
  of items, meetups or groups

  Background:
    Given I am an authenticated user
	And I am on resources
	And I follow "New Resource"
	And I select "Good" from "a" 
	And I fill in "Title" with "My first resource"
    Given I follow "Where"
    When I fill in "Address" with "Berlin, Deutschland"
    And I press "Save"

  @javascript
  Scenario: Set location
    Then I should see "My first resource"
    And I should see "Berlin Germany"
    And I should see an element "div.map_container"

  @javascript
  Scenario: Item maps can be seen even not logged in
  	Given I am on logout
  	And I am on resources
  	And I follow "My first resource"
    And I should see an element "div.map_container"