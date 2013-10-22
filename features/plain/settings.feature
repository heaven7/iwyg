Feature: Settings
  In Order to set settings
  I want to set, edit, create and delete settings

  Scenario: Default ItemSettings: visible_for: "all"
    Given I have a good titled "Hello World"
    Then this "item" with title "Hello World" should have a setting "visible_for" with value "all"