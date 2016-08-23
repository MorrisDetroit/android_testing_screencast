Feature: Inventory Filter
  As a Capture user
  I want to be able to filter vehicle inventory
  So that I can easily find vehicles I have previously captured

  Scenario: Canceling Inventory History Filter does not save changes
    Given I change the Inventory History option in Inventory Filter
    When I click cancel in the Inventory Filter popup
    Then I should see that the Inventory History option is not saved

  Scenario: Saving Inventory History Filter saves changes
    Given I change the Inventory History option in Inventory Filter
    When I click ok in the Inventory Filter popup
    Then I should see that the Inventory History option is saved

  Scenario: Canceling Show Only Filter does not save changes
    Given I change the Show Only option in Inventory Filter
    When I click cancel in the Inventory Filter popup
    Then I should see that the Show Only option is not saved

  Scenario: Saving Show Only Filter saves changes
    Given I change the Show Only option in Inventory Filter
    When I click ok in the Inventory Filter popup
    Then I should see that the Show Only option is saved

  @multi-user-capture
  Scenario: Vehicles Displayed are all mine when Show Only filter is on
    Given I am logged in
    When I turn on the Show Only option in the Inventory Filter
    Then I should see that the results are of my vehicles

  @multi-user-capture
  Scenario: Vehicles Displayed are not only mine when Show Only filter is off
    Given I am logged in
    When I turn off the Show Only option in the Inventory Filter
    Then I should see that the results are a mix of vehicles