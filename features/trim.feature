Feature: Trim
  As a Capture user
  I want to be able to find/select/update trim
  So that I can choose the type of vehicle trim

  Scenario: Vehicle that decodes to single CAN trim has trim populated
    Given I enter a vehicle in capture that decodes to a single CA trim
    Then I should see that the trim is populated

  @pending
  Scenario: Vehicle that decodes to single US trim has trim populated
    Given I enter a vehicle in capture that decodes to a single US trim
    Then I should see that the trim is populated

  Scenario: Trim Finder button is available on vehicle that decodes to multiple trims
    Given I enter a vehicle in capture that decodes to a multiple trims
    Then I should see that the Run Trim Finder button is enabled

  Scenario: Trim Finder button is not available on vehicle that decodes to single CAN trims
    Given I enter a vehicle in capture that decodes to a single CA trim
    Then I should see that the Run Trim Finder button is not enabled

  @pending
  Scenario: Trim Finder button is not available on vehicle that decodes to single US trims
    Given I enter a vehicle in capture that decodes to a single US trim
    Then I should see that the Run Trim Finder button is not enabled

  Scenario: Vehicles with Canadian VINs show trims for each country
    Given I enter a vehicle in capture that has US and Canada trims
    Then I should see the vehicle has trim options for US and CA

  Scenario: Trim Finder returns a single trim after a series of questions
    Given I enter a vehicle in capture that decodes to a multiple trims
    When I use the Trim Finder to find a trim
    Then I should see that the trim is populated

  @prod_bug
  Scenario: Trim Finder returns the correct trim on 2016 Jeep Compass
    Given I start to enter a vehicle in capture with the VIN 1C4NJCBA7GD612077
    When I answer no to the trim finder question about Manual Transmission
    Then I should see that the trim is "FWD 4dr Sport Pkg"

  Scenario: Updating the trim on vehicle requires int and ext color to be reset
    Given I enter a vehicle in capture that decodes to a multiple trims
    When I set the int and ext colors, and then update the trim
    Then I should see that the int and ext colors are no longer populated

  @capture_db
  Scenario: JSON Country value is US for US trims
    Given I enter a vehicle in capture that has US and Canada trims
    When I complete the capture with US trim
    Then I should see country is US in the JSON

  @capture_db
  Scenario: JSON Country value is CAN for CAN trims
    Given I enter a vehicle in capture that has US and Canada trims
    When I complete the capture with CA trim
    Then I should see country is CA in the JSON