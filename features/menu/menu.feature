@javascript
Feature: Menu
  As a user of the website
  I want to have food calculator
  To be able to make menu for my trip

  Background:
    Given I have "1" Menu for "3" days
    And I have "2" public Menus for "2" days
    And I am on Menu page

    Scenario: Menu page should show list of Menu examples
      Then I should see "2" Menus in Menu list

    Scenario: Menu page should show menu entities