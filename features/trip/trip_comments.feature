Feature: Trip comments
  As a user of the website
  I want to be able to leave comments
  To ask/clarify any additional items related to trip

  Background:
    Given I have "1" trip in "Carpathian"

    Scenario: Show login link if user is not logged in
      Given I exist as a user
      And I am not logged in
      When I visit trip page
      Then I should see "Login" link in "Comments" trip area

    Scenario: Show comments from if user is not logged in
      Given I am logged in
      When I visit trip page
      Then I should see Comments form

    Scenario: Logged in user should be able to leave new comments
      Given I am logged in
      When I visit trip page
      And I enter "Great trip" to Comments form
      And I click "Send" button in Comments form
      Then I should see "Great trip" in "Comments" trip area
      And I should see my name in "Comments" trip area