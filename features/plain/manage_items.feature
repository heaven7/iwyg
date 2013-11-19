Feature: Manage Resources (Items)
  In Order to manage items
  As an user
  I want to list, edit, create and delete items

  Background:
    Given my locale is ":en"
    And I am an authenticated user
    And I have a good titled "Hello World"
    And I go to the list of items
    And I click "New resource"
    And I select "need" from "I"
    And I select "Service" from "a"
    And I fill in "Title" with "testitem"
    And I press "Save"

  @javascript
  Scenario: List items
    When I go to the list of items
    Then I should see "Hello World"
    And I should see "testitem"
    And the count of items visible for all should be 2

  Scenario: Show item, when not logged in
    When I am not authenticated
    And I go to the list of items
    And I click "Hello World"
    Then I should see "Hello World"

  Scenario: Create an item (needed)
    Then I should see "Resource created successfully."
    And I should see "Service testitem"
    And I should see "needed by"
    And the count of items visible for all should be 2

  Scenario: Edit an item (needed)
    And I click "edit"
    And I should see "testitem" in field "item_title"
    And I select "Transport" from "a"
    And I select "have" from "I"
    And I fill in "Title" with "testitem2"
    And I press "Save"
    Then I should see "Successfully updated resource."
    And I should see "Transport testitem2"
    And I should see "offered by"

  @javascript
  Scenario: Destroy an item
    And I click "delete"
    And I confirm popup
    Then I should see "Successfully deleted resource."
    Then the count of items visible for all should be 1

