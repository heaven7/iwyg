Feature: Manage Resources (Items)
  In Order to manage items
  As an editor
  I want to list, edit, create and delete items

  Scenario: List Items
    Given I have a good titled "Hello World"
    And I need a good titled "A good day"
    When I go to the list of items
    Then I should see "Hello World"
    And I should see "A good day"