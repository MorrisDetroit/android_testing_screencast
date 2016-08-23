Feature: Work Order Lookup
  As a Capture user
  I want to be able to re-use data from previous captures
  So that I can reduce the amount of time required to perform new captures

  @capture_db
  Scenario: Work Order & Location combination is in Capture DB within the past 3 months
    Given I enter a work order that is in the Capture DB, in IFS, within the past 3 months
    Then I should see that the mileage is populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB within the past 3 months, VIN is in IFS, VIN is in Capture DB
    Given I enter a work order that is in the Capture DB, in IFS, not within the past 3 months
    Then I should see that the vehicle configuration is populated from Capture DB
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB, VIN is NOT in IFS, VIN is in Capture DB
    Given I enter a work order that is not in the Capture DB and not in IFS
    And I enter a VIN that is
      | in Capture DB |
    Then I should see that the vehicle configuration is populated from Capture DB
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB, VIN is NOT in IFS, VIN is NOT in Capture DB, VIN is NOT in VDM
    Given I enter a work order that is not in the Capture DB and not in IFS
    And I enter a VIN that is
      | not in Capture DB |
      | not in VDM        |
    Then I should see that the vehicle configuration is populated from Chrome DB
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are not attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB, VIN is NOT in IFS, VIN is NOT in Capture DB, VIN is in VDM
    Given I enter a work order that is not in the Capture DB and not in IFS
    And I enter a VIN that is
      | not in Capture DB |
      | in VDM            |
    Then I should see that the vehicle configuration is populated from VDM
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are not attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB, VIN is returned by IFS, VIN is in Capture DB
    Given I enter a work order that is not in the Capture DB and in IFS with a VIN that is
      | Capture | present |
      | VDM     | absent  |
    Then I should see that the vehicle configuration is populated from Capture DB
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB, VIN is in IFS, VIN is NOT in Capture DB, VIN is NOT in VDM
    Given I enter a work order that is not in the Capture DB and in IFS with a VIN that is
      | Capture | absent |
      | VDM     | absent |
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are not attached

  @capture_db
  Scenario: Work Order & Location combination is NOT in Capture DB, VIN is in IFS, VIN is NOT in Capture DB, VIN is in VDM
    Given I enter a work order that is not in the Capture DB and in IFS with a VIN that is
      | Capture | absent  |
      | VDM     | present |
    Then I should see that the vehicle configuration is populated from VDM
    And I should see that the mileage is not populated
    When I update the vehicle mileage units to bring record to device
    Then I should see that photos are not attached