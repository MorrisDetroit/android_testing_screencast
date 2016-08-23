Feature: Login
  As a Capture user
  I want to be able to log in & out successfully
  So that I can access the Capture app and perform captures

  Scenario: Login successful with valid credentials
    Given I log in with
      | username | valid |
      | password | valid |
    Then I should be successfully logged in

  Scenario: Login fails with invalid credentials
    Given I log in with
      | username | invalid |
      | password | invalid |
    Then I should not be logged in

  Scenario: Login fails with invalid username
    Given I log in with
      | username | invalid |
      | password | valid |
    Then I should not be logged in

  Scenario: Login fails with invalid password
    Given I log in with
      | username | valid |
      | password | invalid |
    Then I should not be logged in

  Scenario: Login fails with no username given
    Given I log in with
      | username | none |
      | password | valid |
    Then I should not be logged in

  Scenario: Login fails with no password given
    Given I log in with
      | username | valid |
      | password | none |
    Then I should not be logged in

  Scenario: Login fails with no username or password given
    Given I log in with
      | username | none |
      | password | none |
    Then I should not be logged in

  Scenario: User is taken to the Main Menu after logging off
    Given I am logged in
    When I log out
    Then I should see that I am on the login screen