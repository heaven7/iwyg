Feature: Likes
  In Order to implement Likes
  As a logged in user
  I want to like and unlike objects

  Background:
  Given I am an authenticated user

  @javascript
  Scenario: Liking a resource (item)
    Given I have a good titled "Hello World"
    And I am on the list of items 
    When I follow "Hello World"
    Then I should see "Hello World"
    #And I follow "likebutton"
    #Then I should see "You like 'Hello World'."