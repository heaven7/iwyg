Feature: Likes
  In Order to implement Likes
  As a logged in user
  I want to like and unlike objects

  Background:
  Given I am an authenticated user
  And I have a good titled "Hello World"

  @javascript
  Scenario: Liking a resource (item)
    Given I am on the list of items 
    When I follow "Hello World"
    And I follow "like"
    Then I should see "You like 'Hello World'."