Feature: Item types test
  In Order to let items have different item types
  I want to test all item types

  @focus
  Scenario: item type
  Given I have a item of type "good"
  Then the itemtype should be 1