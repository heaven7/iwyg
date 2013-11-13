Feature: Manage groups
  In Order to manage groups
  As an user
  I want to list, edit, create and delete groups

  Background:
    Given my locale is ":en"
    And I am an authenticated user
    And I go to the list of groups
    And I click "New group"
    And I fill in "Title" with "testgroup"
    And I fill in "Description" with "group description"
    And I press "Save"

  Scenario: List groups
    When I go to the list of groups
    And I should see "testgroup"
    And I should have 1 group

  Scenario: Create a group
    Then I should see "Successfully saved group."
    And I should see "testgroup"
    And I should have 1 group

  @javascript @focus
  Scenario: See a group
    And I go to the list of groups
    Then I should see "testgroup"
    And I follow "testgroup"
    And I should see "group description"

  Scenario: Edit an group
    And I click "edit"
    And I should see "testgroup" in field "group_title"
    And I fill in "Title" with "testgroup2"
    And I press "Save"
    Then I should see "Successfully updated group."
    And I should see "testgroup2"

  @javascript
  Scenario: Destroy an group
    And I click "delete"
    And I confirm popup
    Then I should see "Group was successfully destroyed."
    Then I should have 1 group

