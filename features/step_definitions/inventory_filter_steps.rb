When(/^I change the Inventory History option in Inventory Filter$/) do
  @capture.login_page.login
  @capture.vehicle_listings_page.inventory_filter_link.click
  @previous_setting = @capture.inventory_filter.inventory_history.text
  @capture.inventory_filter.inventory_history.click
  @capture.update_option(@previous_setting)
end

When(/^I click (cancel|ok) in the Inventory Filter popup$/) do |operator|
  @capture.inventory_filter.cancel_button.click if operator.eql? "cancel"
  @capture.inventory_filter.ok_button.click if operator.eql? "ok"
end

Then(/^I should see that the Inventory History option is( not)? saved$/) do |negative|
  @capture.vehicle_listings_page.inventory_filter_link.click
  @current_setting = @capture.inventory_filter.inventory_history.text
  if negative.eql?(" not")
    expect(@current_setting).to eql @previous_setting
  else
    expect(@current_setting).not_to eql @previous_setting
  end
end

Then(/^I should see that the results are of my vehicles$/) do
  expect(@capture.vehicle_listings_page.listing_created_by?("auto2")).to be false
end

Then(/^I should see that the results are a mix of vehicles$/) do
  expect(@capture.vehicle_listings_page.listing_created_by?("auto2")).to be true
end

When(/^I change the Show Only option in Inventory Filter$/) do
  @capture.login_page.login
  @capture.vehicle_listings_page.inventory_filter_link.click
  @previous_setting = @capture.inventory_filter.show_only_my_vehicles_option.text
  @capture.inventory_filter.show_only_my_vehicles_option.click
end

Then(/^I should see that the Show Only option is( not)? saved$/) do |negative|
  @capture.vehicle_listings_page.inventory_filter_link.click
  @current_setting = @capture.inventory_filter.show_only_my_vehicles_option.text
  if negative.eql?(" not")
    expect(@current_setting).to eql @previous_setting
  else
    expect(@current_setting).not_to eql @previous_setting
  end
end

When(/^I turn (on|off) the Show Only option in the Inventory Filter$/) do |operator|
  @capture.vehicle_listings_page.inventory_filter_link.click
  (operator.eql? "on") ?
      @capture.inventory_filter.set_show_only_my_vehicles :
      @capture.inventory_filter.clear_show_only_my_vehicles
  @capture.inventory_filter.ok_button.click
end