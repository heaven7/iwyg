Feature: Search
  In Order to search items
  I want to search by title, by itemtype, by tags, location based (range) and by need / offer

  Background:
    Given I have a good titled "Hello World"
    And I tag the item "Hello World" with "testtag"
    And I add to item "Hello World" the location "München, Deutschland"
    And I am on the list of items

  Scenario: Search by title
    When I fill in "q_title_cont" with "Hello World"
    And I press "submit-search"
    Then I should see "Hello World"
    And I should see "1 Resource found"

  Scenario: Search by itemtype
    When I click "advanced_search"
    And I select "Transports" from "item_type_id_eq"
    And I press "submit-search" 
    Then I should not see "Hello World"
    And I should see "0 Transports found"

  Scenario: Search by tag
    When I click "Hello World"
    And I click "testtag"
    Then I should see "Hello World"
    And I should see "with tag: testtag"
    And I should see "1 Resource found"

  @focus @javascript
  Scenario: Search by location
    When I fill in "near" with "München, Deutschland"
    And I press "submit-search"
    Then I should see "Hello World"
    And I should see "1 Resource found"