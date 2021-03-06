Feature: Locations
  In Order to integrate locations
  I want to show maps and let users manage their locations
  of items, meetups or groups

  Background:
    Given my locale is ":en"
    And I am an authenticated user
  	And I am on resources
  	And I follow "New resource"
  	And I select "Good" from "a" 
  	And I fill in "Title" with "My first resource"
    Given I click "Where"
    When I fill in "Address" with "Berlin, Deutschland"
    And I fill in "City" with "Berlin"
    And I fill in "Country" with "Deutschland"
    And I fill in "Latitude" with "52.52000659999999"
    And I fill in "Longitude" with "13.404953999999975"
    And I press "Save"

  @javascript
  Scenario: Set location on item
    Then I should see "My first resource"
    And I should see an element "div.map_container"
    And the locations count of item "My first resource" should be 1
    #And I should see "Berlin Germany"
    
  @javascript 
  Scenario: Item maps can be seen even when not logged in
  	Given I am on logout
  	And I am on resources
  	And I follow "My first resource"
    And I should see an element "div.map_container"

  @javascript
  Scenario: Create group and add location to it
    And I am on groups
    And I follow "New group"
    And I fill in "Title" with "testgroup"
    And I click "Where"
    And I fill in "Address" with "München, Germany"
    And I fill in "City" with "München"
    And I fill in "Country" with "Deutschland"
    And I fill in "Latitude" with "48.1351253"
    And I fill in "Longitude" with "11.581980599999952"
    And I press "Save"
    Then I should see "Successfully saved group."
    And I should see "testgroup"
    #And I should see "Munich Germany"
    And I should see an element "div.map_container"
    And the locations count of group "testgroup" should be 1