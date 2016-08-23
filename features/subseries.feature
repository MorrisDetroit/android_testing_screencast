Feature: Subseries
  As a Capture user
  I want to be able to update vehicle subseries
  So that I can correct any invalid subseries data

  @capture_db
  Scenario: JSON: Trim & Subseries JSON values match values from UI
    Given I add a vehicle with pre-defined subseries
    Then I should see the trim and subseries values in the JSON

  Scenario: Subseries list matches expected subseries for VIN pattern
    Given I start to add a vehicle with multiple subseries
    Then I should see that the subseries matches the csv file

  Scenario: Subseries is saved to the PF_Vehicle table
    Given I add a vehicle with pre-defined subseries
    Then I should see that the subseries is saved to PF_Vehicle

  @capture_db
  Scenario: JSON: User enters free text for subseries
    Given I add a vehicle with user defined subseries
    Then I should see the user defined subseries flag is 1 in the JSON

  @capture_db
  Scenario: JSON: User selects pre-defined subseries
    Given I add a vehicle with pre-defined subseries
    Then I should see the user defined subseries flag is 0 in the JSON

  @capture_db
  Scenario: JSON: User selects (NONE) for subseries Given there are no other options
    Given I start to add a vehicle with a single blank subseries
    When I finish the capture with subseries (NONE)
    Then I should see the user defined subseries flag is 0 in the JSON

  Scenario: Pre-selection: Vehicle with a single subseries (NONE) auto-populates to (NONE)
    Given I start to add a vehicle with a single blank subseries
    Then I should see that (NONE) is pre-selected for subseries

  Scenario: Pre-selection: Vehicle with a single subseries (other than NONE) auto-populates to X
    Given I start to add a vehicle with a single non blank subseries
    Then I should see that X is pre-selected for subseries

  Scenario: Hints: Trim and subseries hints for BMW VDM vehicles
    Given I start to add a BMW VDM vehicle
    Then I should see 2 hints for trim & subseries

  Scenario: Hints: Only Trim name hint shows on the subseries screen
    Given I start to add a non-VDM vehicle
    Then I should see 1 hint for trim & subseries