Feature: Item types test
  In Order to let items have different item types
  I want to test all item types

  Scenario: good
  Given I have a item of type "good"
  Then the itemtype should be 1

  Scenario: transport
  Given I have a item of type "transport"
  Then the itemtype should be 2

  Scenario: service
  Given I have a item of type "service"
  Then the itemtype should be 3
  
  Scenario: sharingpoint
  Given I have a item of type "sharingpoint"
  Then the itemtype should be 4

  Scenario: knowledge
  Given I have a item of type "knowledge"
  Then the itemtype should be 5

  Scenario: skill
  Given I have a item of type "skill"
  Then the itemtype should be 6