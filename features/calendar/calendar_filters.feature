@javascript
Feature: Calendar filters
  As a user of the website
  I want to filter trips by region
  To find trips in a specified region

    Scenario: Filters should show list of regions
      Given I have "2" trips in "Carpathian"
      And I have "2" trips in "Crimea"
      And I am on calendar page
      Then I should see "Carpathian" in filters
      And I should see "Crimea" in filters

    Scenario: Filters should filter trips on calendar
      Given I have "3" trips in "Carpathian"
      And I have "2" trips in "Crimea"
      And I am on calendar page
      When I click "Carpathian" in filers
      Then I should see "3" trips in calendar