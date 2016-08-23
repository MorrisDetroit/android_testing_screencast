Feature: Photos
  As a Capture user
  I want to be able to add/delete photos of vehicles
  So that I can capture vehicle images

  Scenario: Photos page contains the 7 required photos
    Given I am on the photo tab of a new vehicle
    Then I should see the following photo boxes
      | Odometer    |
      | Ctr Dash    |
      | Mfg. Tag    |
      | Lft Fr Int. |
      | Left Front  |
      | Cargo       |
      | Rt Rear     |

  Scenario: All 7 required photo boxes have Required label
    Given I am on the photo tab of a new vehicle
    Then I should see that all 7 boxes are labeled as required

  Scenario: Required photos contain Required label, and Photo name
    Given I am on the photo tab of a new vehicle
    When I click on a box to take a new photo
    Then I should see that the photo page is labeled as required
    And I should see that the photo name is on the page

  Scenario: Successfully save photo
    Given I am on the photo tab of a new vehicle
    When I take and save a new photo
    Then I should see that the photo is saved

  Scenario: Back button on photos page navs to Photo main page
    Given I am on the photo tab of a new vehicle
    When I click on the photo page back button
    Then I should be taken to the Vehicle Listings page

  Scenario: Device back button when taking photo takes you to Photo main page
    Given I am on the photo tab of a new vehicle
    And I click on a box to take a new photo
    When I click the device back button
    Then I should be taken to the Photo main page

  Scenario: Successfully Delete photo
    Given I add 2 photos to a vehicle
    When I delete a photo I have taken
    Then I should see that the photo has been deleted

  Scenario: Cancel Delete action leaves photo saved
    Given I add a photo to a vehicle
    When I cancel the delete action on a photo
    Then I should see that the photo has not been deleted

  Scenario: Vehicle Page shows number of photos taken
    Given I have a vehicle with photos taken
    Then I should see that the photo count image is displayed

  Scenario: Vehicle with no photos taken does not display photo count
    Given I have a vehicle with no photos taken
    Then I should see that the photo count image is not present

  @prod_bug @manual
  Scenario: Photos show on the device but not in GoldenGate or Capture Admin
    Given I have a vehicle entered through capture
    When I re-take a photo 3 times
    Then I should see that the image url is valid

  # Hard to validate image is different with automation
  @prod_bug @manual
  Scenario: Photos that fail to download due to network issues can be re-taken
    Given I start to add a previously captured vehicle
    And I turn off the wifi
    And I re-take a missing photo
    When I turn on the wifi and sync the vehicle
    Then I should see that the new photo is saved

  # Hard to validate image is different with automation
  @prod_bug @manual
  Scenario: Photos that are downloaded manually should not overwrite existing photos
    Given I start to add a previously captured vehicle
    And I turn off the wifi
    And I re-take a missing photo
    And I turn on the wifi
    When I download photos manually
    Then I should see that the photo is not replaced

  @prod_bug @manual
  Scenario: Photos can be downloaded manually
    Given I start to add a previously captured vehicle
    And I turn off the wifi
    When I download photos manually and go back
    Then I should see that the photo count is 7

  # Hard to validate image is different with automation
  @prod_bug @manual
  Scenario: Photos that are downloaded can be replaced after turning on wifi
    Given I start to add a previously captured vehicle
    And I turn off the wifi
    And I delete a photo that was downloaded
    And I turn on the wifi
    When I re-take the photo that was deleted
    Then I should see that the new photo is saved

  # Hard to validate image is different with automation
  @prod_bug @manual
  Scenario: Photos that are downloaded and re-taken before turning wifi on can be replaced
    Given I start to add a previously captured vehicle
    And I turn off the wifi
    And I delete a photo that was downloaded
    When I re-take the photo that was deleted
    And I turn on the wifi
    Then I should see that the new photo is saved