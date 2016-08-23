Feature: Add Vehicle
  As a Capture user
  I want to be able to add vehicles
  So that I can capture vehicle information

  Scenario: PF_Vehicle table updates when a vehicle is added
    Given I have a vehicle entered through capture
    Then I should see that the vehicle is updated in the PF_Vehicle table

  Scenario: PF_Vehicle table updates when a pre-1992 vehicle is added
    Given I have a pre-1992 vehicle entered through capture
    Then I should see that the vehicle is updated in the PF_Vehicle table

  Scenario: Additional tab shows specific options for SUV
    Given I decode a vin that has a SUV body style
    Then I should see that the additional tab has SUV options

  @pending
  Scenario: Additional tab shows specific options for Truck
    Given I decode a vin that has a Truck body style
    Then I should see that the additional tab has Truck options

  Scenario: Additional tab shows specific options for Van
    Given I decode a vin that has a Van body style
    Then I should see that the additional tab has Van options

  @prod_bug
  Scenario: VIN decodes to multiple models, trim selection should not wipe out model
    Given I enter a vehicle in capture that decodes to multiple models
    Then I should see that the vehicle is updated in the PF_Vehicle table

  @hybrid
  Scenario: Incomplete vehicle capture displays warning icon on the vehicle
    Given I partially enter a vehicle into capture
    Then I should see the incomplete vehicle warning icon

  @hybrid
  Scenario: Completed vehicle capture displays green success icon on the vehicle
    Given I have a vehicle with photos taken
    Then I should see the green success icon