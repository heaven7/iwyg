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

  Scenario: Default ItemSettings
    Then this "item" with title "testitem" should have a setting "visible_for" with value "all"
  @javascript @focus
  Scenario: Edit ItemSetting 'visible_for' to "me"
    And I am on the list of items
  	And I click "testitem"
  	And I click "edit"
  	Given I click "Settings"
  	And I select "me" from "item_itemsettings_visible_for"
    And I press "Save"
  	When I am on logout
  	And I go to the list of items
  	Then I should not see "testitem"
  	And this "item" with title "testitem" should have a setting "visible_for" with value "me"
