Feature: Follows
  In Order to implement follows / follower
  As a logged in user
  I want to follow and unfollow objects

  Background:
    Given my locale is ":en"
    And I am an authenticated user
    And I have a good titled "Hello World"

  @javascript @focus
  Scenario: Follow a resource (item)
    Given I am on the list of items 
    When I follow "Hello World"
    And I follow "follow"
    Then I should see "You are following 'Hello World'"