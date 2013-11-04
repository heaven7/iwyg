Feature: Follows
  In Order to implement follows / follower
  As a logged in user
  I want to follow and unfollow objects

  Background:
    Given my locale is ":en"
    And I have one user "testing" with email "test@drive.net" and password "secretpass"
    And I am an authenticated user
    And I have a good titled "Hello World"

  @javascript
  Scenario: Following a resource (item) 
    Given I am on the list of items
    When I follow "Hello World"
    And I click "follow"
    Then I should see "You are following 'Hello World'."
    And the following count of item "Hello World" should be 1

  @javascript
  Scenario: Unfollowing a resource (item) 
    Given I am on the list of items
    When I follow "Hello World"
    And I click "follow"
    And I click "don't follow anymore"
    Then I should see "You don't follow 'Hello World' anymore."
    And the following count of item "Hello World" should be 0

  @javascript
  Scenario: Following a user 
    Given I am on the list of users
    When I follow "testing"
    And I click "follow"
    Then I should see "You are following 'testing'."
    And the following count of user "testing" should be 1

  @javascript
  Scenario: Unfollowing a user 
    Given I am on the list of users
    When I follow "testing"
    And I click "follow"
    And I click "don't follow anymore"
    Then I should see "You don't follow 'testing' anymore."
    And the following count of user "testing" should be 0
