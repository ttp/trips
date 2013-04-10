@javascript
Feature: Join trip
  As a user of the website
  I want to be able to send Join Trip request
  To book a place in a trip

  Background:
    Given I have "1" trip in "Carpathian"
    And a clear email queue

    Scenario: Show login link if user is not logged in
      Given I exist as a user
      And I am not logged in
      When I visit trip page
      Then I should see "Login" link in "Trip users" area

    Scenario: Show join button if user is logged in
      Given I am logged in
      When I visit trip page
      Then I should see "Join" button

    Scenario: Join button should add user to Want to join list
      Given I am logged in
      When I visit trip page
      And I click "Join" button
      Then I should see my name in "Want to join" area
      And I should see "Leave" icon in "Want to join" area
      And I should receive an email with subject "New join request notification"
      And Trip owner should receive an email with subject "New join request notification"

    Scenario: Leave button should remove user from trip users
      Given I am logged in
      When I visit trip page
      And I click "Join" button
      And I click "Leave" icon
      And I accept confirm dialog
      Then I should not see my name in "Want to join" area
      And Trip owner should receive an email with subject "User has left trip"
    
    @active
    Scenario: Trip owner should be able to approve join request
      Given Trip has join request for user "Super Tracker"
      When I sign in as trip owner
      And I visit trip page
      And I click "Approve" icon
      Then I should not see "Super Tracker" in "Want to join" area
      And I should see "Super Tracker" in "Joined users" area
      And user "Super Tracker" should receive an email with subject "Your join request has been approved"