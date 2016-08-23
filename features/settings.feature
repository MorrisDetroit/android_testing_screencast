Feature: Settings
  As a Capture user
  I want to be able to change the settings
  So that I can configure Capture settings

  Scenario: AiM Inspect link in the About Section displays app & chrome versions
    Given I am in the Settings Menu
    When I click on AiM Inspect
    Then I should see the current app version displayed
    And I should see the current chrome version displayed

  Scenario: Clicking OK from AiM Inspect popup navs back to Settings Menu
    Given I am in the Settings Menu
    And I click on AiM Inspect
    When I select OK from the AiM Inspect popup
    Then I should be taken to the Vehicle Listings page

  Scenario: Clicking device back button in Settings Menu navs to Vehicle Listings page
    Given I am in the Settings Menu
    When I click the device back button
    Then I should be taken to the Vehicle Listings page

  Scenario: Clicking back arrow in Settings Menu navs to the Vehicle Listings page
    Given I am in the Settings Menu
    When I click on the Settings menu back arrow
    Then I should be taken to the Vehicle Listings page

  Scenario: Upload log properly uploads from Settings Menu
    Given I am in the Settings Menu
    When I click on Upload Log
    Then I should see "Completed." displayed in the upload log popup

  Scenario: Clicking OK from Upload Log popup navs back to the Settings Menu
    Given I am in the Settings Menu
    When I click on Upload Log
    And I click OK in the upload log popup
    Then I should be taken to the Settings Menu

  Scenario: Color Equipment Values link displayed on Settings Menu
    Given I am in the Settings Menu
    Then I should see the Color Equipment Values link

  Scenario: Settings Menu Barcode Scanner Focus Options
    Given I am in the Settings Menu
    When I click on Barcode Scanner Focus
    Then I should see the following focus options
      | auto               |
      | infinity           |
      | normal             |
      | macro              |
      | continuous-picture |
      | continuous-video   |

  Scenario: Selecting radio option on Barcode Scanner Focus saves changes
    Given I am in the Settings Menu
    When I change the Barcode Scanner Focus settings
    Then I should see that the Barcode Scanner Focus Setting has been saved

  Scenario: Clicking Cancel on Barcode Scanner Focus does not save changes
    Given I am in the Settings Menu
    When I click cancel on the Barcode Scanner Focus setting popup
    Then I should see that the Barcode Scanner Focus setting has not changed

  Scenario: Settings Menu Photo Overlay Duration Options
    Given I am in the Settings Menu
    When I click on Photo Overlay Duration
    Then I should see the following duration options
      | Disabled    |
      | 0.5 Second  |
      | 1 Second    |
      | 1.5 Seconds |
      | 2 Seconds   |
      | 2.5 Seconds |
      | 3 Seconds   |

  Scenario: Selecting radio option on Photo Overlay Duration saves changes
    Given I am in the Settings Menu
    When I change the Photo Overlay Duration settings
    Then I should see that the Photo Overlay Duration Setting has been saved

  Scenario: Clicking Cancel on Photo Overlay Duration does not save changes
    Given I am in the Settings Menu
    When I click cancel on the Photo Overlay Duration setting popup
    Then I should see that the Photo Overlay Duration setting has not changed

  @pwchange
  Scenario: Successfully updating password invalidates old password
    Given I have successfully updated my password
    And I log out from the Settings Menu
    When I try to sign in with my old credentials
    Then I should not be logged in

  @pwchange
  Scenario: Successfully updating password allows sign in with new password
    Given I have successfully updated my password
    And I log out from the Settings Menu
    When I try to sign in with my new credentials
    Then I should be successfully logged in

  @hybrid
  Scenario: Checking Color Equipment Values option enables background highlighting
    Given I am in the Settings Menu
    When I check the Color Equipment Values option
    And I start to manually add a new vehicle
    Then I should see background colors on the Optional & Aftermarket tabs

  @hybrid
  Scenario: Checking Color Equipment Values option enables background highlighting
    Given I am in the Settings Menu
    When I uncheck the Color Equipment Values option
    And I start to manually add a new vehicle
    Then I should not see background colors on the Optional & Aftermarket tabs

  @hybrid
  Scenario: Changing Password with invalid credentials displays error message
    Given I am in the Settings Menu
    When I change my password using incorrect credentials
    Then I should see "Invalid Credentials" message on the change password page

  @hybrid
  Scenario: Changing Password without matching new passwords displays error message
    Given I am in the Settings Menu
    When I change the password without matching new passwords
    Then I should see "New password does not match the confirm password" message on the change password page