@javascript
Feature: Menu for Guest
  As a user of the website
  I want to make menu for my trip even without login

  Background:
    Given I have "Menu example one" not empty Menu
    And I am on Menus page

    Scenario: User should see Add menu button
      Then I should see "Create menu" link

    Scenario: User should be able to save menu
      When I click "Create menu" link
      And I fill in "name" with "Guest menu"
      And I add day to menu
      And I click "Save" button
      Then I should be on "Guest menu" menu page
      And I should see "Edit" link