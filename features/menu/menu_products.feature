Feature: Menu Products
  As a user of the website
  I want to have products catalog
  To be able to add/remove products and to get detailed info about each

  Background:
    Given I have "3" categories with "3" products

    Scenario: Products page should show categories
      When I visit products page
      Then I should see "3" categories

    Scenario: Products page should show products
      When I visit products page
      Then I should see "9" products

    Scenario: Category filters products
      When I visit products page
      And I click first category link
      Then I should see "3" products

  Scenario: Guest should not see Add product link
    When I visit products page
    Then I should not see "Add Product" link

  Scenario: Logged in user should see Add product link
    Given I am logged in
    And I visit products page
    Then I should see "Add Product" link

  Scenario: Create product
    Given I have "Test category" category
    And I am logged in
    And I visit products page
    And I click "Add Product" link
    And I fill in "Test product" product for "Test category"
    And I click "Save" button
    Then I should be on products page
    And I should see "Test product" in products