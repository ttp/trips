@javascript
Feature: Menu
  As a user of the website
  I want to have food calculator
  To be able to make menu for my trip

  Background:
    Given I have "Menu example one" not empty Menu
    And I have "Menu example two" not empty Menu
    And I have "Menu three" private Menu
    And I am on Menus page

    Scenario: Menu page should show list of Menu examples
      Then I should see "2" Menus in Menu list

    @active
    Scenario: Menu page should show menu entities
      When I click "Menu example one" link
      Then I should see menu entities
      And I should see menu summary
      And I should see list of products