Feature: Likes
  In Order to implement Likes
  As a logged in user
  I want to like and unlike objects

  Background:
    Given my locale is ":en"
    And I have one user "testing" with email "test@drive.net" and password "secretpass"
    And I am an authenticated user
    And I have a good titled "Hello World"

  @javascript
  Scenario: Liking a resource (item)
    Given I am on the list of items 
    When I follow "Hello World"
    And I follow "like"
    Then I should see "You like 'Hello World'."

  @javascript 
  Scenario: Unliking a resource (item) 
    Given I am on the list of items
    When I follow "Hello World"
    And I click "like"
    And I click "don't like anymore"
    Then I should see "You don't like 'Hello World' anymore."
    And the liking count of item "Hello World" should be 0

  @javascript
  Scenario: Liking a user 
    Given I am on the list of users
    When I follow "testing"
    And I click "like"
    Then I should see "You like 'testing'."
    And the liking count of user "testing" should be 1

  @javascript
  Scenario: Unliking a user 
    Given I am on the list of users
    When I follow "testing"
    And I click "like"
    And I click "don't like anymore"
    Then I should see "You don't like 'testing' anymore."
    And the liking count of user "testing" should be 0