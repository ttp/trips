@javascript
Feature: Calendar
  As a user of the website
  I want to have a Trips calendar
  To find trips in a specified month/day

  Background:
    Given I have "3" trips in "Carpathian"
    And I have "2" trips in "Crimea"
    And I am on calendar page

    Scenario: Calendar should show backpacker in days with trips
      Then I should see backpacker icon

    Scenario: Clicking on backpacker icon should show list of trips
      When I click backpacker icon
      Then I should see list of trips with "5" trips

    Scenario: Closing trips list should show filters
      When I click backpacker icon
      And I close trips list
      Then I should see filters list