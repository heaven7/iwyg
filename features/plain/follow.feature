Feature: Follows
  In Order to implement follows / follower
  As a logged in user
  I want to follow and unfollow objects

  Background:
    Given my locale is ":en"
    And I am an authenticated user
    And I have a good titled "Hello World"
    Given I am on the list of items 
    When I follow "Hello World"
    And I follow "follow"

  @javascript
  Scenario: Follow a resource (item)
    Then I should see "You are following 'Hello World'."
    And the following count of item "Hello World" should be 1

  @javascript @focus
  Scenario: Unfollow a resource (item)
    When I follow "unfollow"
    Then I should see "You are following 'Hello World'."
    And the following count of item "Hello World" should be 0