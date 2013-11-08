Feature: Manage Resources (Items)
  In Order to manage items
  As an user
  I want to list, edit, create and delete items

  Background:
    Given my locale is ":en"
    And I am an authenticated user
    And I have a good titled "Hello World"
    And I need a good titled "A good day"

  @focus
  Scenario: List Items
    When I go to the list of items
    Then I should see "Hello World"
    And I should see "A good day"
    And I should have 2 items