Feature: Settings
  In Order to set settings
  I want to set defaults, edit, create and delete settings

  Background:
    Given my locale is ":en"
    And I am an authenticated user
    And I am on the list of items
    And I click "New resource"
    And I select "need" from "I"
    And I select "Service" from "a"
    And I fill in "Title" with "testitem"
    And I press "Save"
    And I am on the list of groups
    And I click "New group"
    And I fill in "Title" with "testgroup"
    And I press "Save"

  Scenario: Default ItemSettings
    Then this "item" with title "testitem" should have a setting "visible_for" with value "all"
  
  Scenario: Default GroupSettings
    Then this "group" with title "testgroup" should have a setting "visible_for" with value "all"

  Scenario: Edit ItemSetting 'visible_for' to "me", the item will no longer be listed
    And I am on the list of items
  	And I click "testitem"
  	And I click "edit"
  	Given I click "Settings"
  	And I select "Me" from "item_itemsettings_visible_for"
    And I press "Save"
  	When I am on logout
  	And I go to the list of items
  	Then I should not see "testitem"
  	And this "item" with title "testitem" should have a setting "visible_for" with value "me"
    And the count of items visible for all should be 0

  @focus @javascript
  Scenario: Show item, when not logged in and not visible
    When I set the visibility of item "testitem" to "me"
    And I am not authenticated
    And I set path to /items/testitem
    Then I should see "Resource not found or not visible."

  @focus
  Scenario: By Edit GroupSetting 'visible_for' to "me", the group will no longer be listed
    And I am on the list of groups
    And I click "testgroup"
    And I click "edit"
    Given I click "Settings"
    And I select "Me" from "group_groupsettings_visible_for"
    And I press "Save"
    When I am on logout
    And I go to the list of groups
    Then I should not see "testgroup"
    And this "group" with title "testgroup" should have a setting "visible_for" with value "me"
    And the count of groups visible for all should be 0
    

  