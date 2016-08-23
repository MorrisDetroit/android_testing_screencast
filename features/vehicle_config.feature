Feature: Vehicle Configuration
  As a Capture user
  I want to be able update vehicle configuration
  So that I can change previously captured vehicle information

  Scenario: Inoperable checkbox for mileage disables mileage field
    And I start to manually add a new vehicle
    When The Inoperable box is checked for mileage
    Then I should see that I can not enter mileage for the vehicle

  Scenario: Miles and Kilometers are options when entering a vehicle
    And I start to manually add a new vehicle
    When I enter mileage
    Then I should be able to pick between Miles and Kilometers

  Scenario: Year, Make, and Model are all populated on a Vin that decodes
    Given I enter a vehicle vin that decodes
    Then I should see that the Year, Make, and Model are populated

  Scenario: Updating Interior color updates PF_Vehicle table
    Given I have a vehicle entered through capture
    When I update the interior color
    Then I should see the interior color updated in the PF_Vehicle table #SINTCO

  Scenario: Loading all engines populates the engine drop down with ALL engine options
    And I start to manually add a new vehicle
    When I select the load additional engines option
    Then I should see the following engine options:
      | 1 Cylinder Engine          |
      | 10 Cylinder Engine         |
      | 12 Cylinder Engine         |
      | 2 Cylinder Engine          |
      | 3 Cylinder Engine          |
      | 4 Cylinder Engine          |
      | 5 Cylinder Engine          |
      | 8 Cylinder Engine          |
      | Electric Motor             |
      | Flat 6 Cylinder Engine     |
      | Rotary Engine              |
      | Straight 6 Cylinder Engine |
      | V6 Cylinder Engine         |

  @prod_bug
  Scenario: Vehicle has a mismatch in trim between VDM and Chrome
    When I start to enter a vehicle in capture with the VIN 1N6AA07F28N344632
    Then I should see that the vehicle configuration is populated from VDM
    When I scroll trim into view
    Then I should see that the trim is populated

  @prod_bug
  Scenario: Previous captures with inoperable checkbox fail to bring back 0 miles
    And I add a vehicle with inoperable odometer
    And I delete the vehicle from the inventory list
    When I start to enter a vehicle with the same vin
    Then I should see that the mileage is 0
    And I should see that the new record in PF_Vehicle has previous capture data

  @hybrid
  Scenario: Required fields are required when adding a vehicle
    And I start to manually add a new vehicle
    Then I should see that the following fields are required
      | transmission   |
      | exterior color |
      | interior color |
      | seat trim      |
      | wheels         |
      | roof type      |
      | mileage        |