Given(/^I am on the photo tab of a new vehicle$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.vehicle_menu.scroll_menu_left
  @capture.vehicle_menu.photo_tab.click
  wait_until { @capture.photos_page.standard_photos.present? }
  @capture.photos_page.standard_photos.click
end

Then(/^I should see the following photo boxes$/) do |table|
  expect(@capture.photos_page.odometer).to be_present
  expect(@capture.photos_page.center_dash).to be_present
  expect(@capture.photos_page.mfg_tag).to be_present
  expect(@capture.photos_page.left_front_interior).to be_present
  expect(@capture.photos_page.left_front_exterior).to be_present
  expect(@capture.photos_page.cargo).to be_present
  expect(@capture.photos_page.right_rear).to be_present
end

Then(/^I should see that all 7 boxes are labeled as required$/) do
  sleep(1)
  expect(@capture.photos_page.required_logos.size).to eql(7)
end

When(/^I click on a box to take a new photo$/) do
  wait_until { @capture.photo_page.odometer.present? }
  @capture.photos_page.odometer.click
end

Then(/^I should see that the photo page is labeled as required$/) do
  wait_until { @capture.photo_page.required_logo.present? }
  expect(@capture.photo_page.required_logo).to be_present
end

Then(/^I should see that the photo name is on the page$/) do
  wait_until { @capture.photo_page.odometer.present? }
  expect(@capture.photo_page.odometer).to be_present
end

When(/^I take and save a new photo$/) do
  @capture.photos_page.odometer.click
  wait_until { @capture.photo_page.shutter_button.present? }
  @capture.photo_page.shutter_button.click
  wait_until { @capture.photo_page.photo_ok.present? }
  @capture.photo_page.photo_ok.click
  3.times do
    @capture.browser.driver.press_keycode(4)
    sleep(1)
  end
end

Then(/^I should see that the photo is saved$/) do
  expect(@capture.vehicle_listings_page.listing_photo_count_by_vin(@vehicle.vin).text).to eql "1"
end

When(/^I click on the photo page back button$/) do
  @capture.browser.driver.press_keycode(4)
  sleep(1)
  @capture.main_menu.nav_menu.click
end

Then(/^I should be taken to the Photo main page$/) do
  wait_until { @capture.photo_page.odometer.present? }
  expect(@capture.photos_page.odometer).to be_present
end

When(/^I delete a photo I have taken$/) do
  @capture.photo_page.delete.click
  3.times do
    @capture.browser.driver.press_keycode(4)
    sleep(1)
  end
end

Then(/^I should see that the photo has been deleted$/) do
  expect(@capture.vehicle_listings_page.listing_photo_count_by_vin(@vehicle.vin).text).to eql("1")
end

Then(/^I should see that the photo count is (\d+)$/) do |count|
  expect(@capture.vehicle_listings_page.listing_photo_count_by_vin(@vehicle.vin).text).to eql(count.to_s)
end

When(/^I cancel the delete action on a photo$/) do
  @capture.photo_page.delete.click
  @capture.photo_page.cancel_delete.click
  @capture.browser.driver.press_keycode(4)
  sleep(1)
  @capture.browser.driver.press_keycode(4)
end

Then(/^I should see that the photo has not been deleted$/) do
  expect(@capture.vehicle_listings_page.listing_photo_count_by_vin(@vehicle.vin).text).to eql("1")
end

Given(/^I add a photo to a vehicle$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.hide_keyboard_if_present
  @capture.add_photo_to_listing
  wait_until { @capture.photos_page.odometer.present? }
  @capture.photos_page.odometer.click
end

Given(/^I add 2 photos to a vehicle$/) do
  @capture.login_page.login
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.hide_keyboard_if_present
  @capture.add_two_photos_to_listing
  wait_until { @capture.photos_page.odometer.present? }
  @capture.photos_page.odometer.click
end

Given(/^I have a vehicle with photos taken$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.hide_keyboard_if_present
  @capture.add_photo_to_listing
  3.times do
    @capture.browser.driver.press_keycode(4)
    sleep(1)
  end
end

Then(/^I should see that the photo count image is displayed$/) do
  expect(@capture.vehicle_listings_page.listing_photo_count_by_vin(@vehicle.vin)).to be_present
end

Given(/^I have a vehicle with no photos taken$/) do
  @capture.login_page.login
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.browser.driver.press_keycode(4)
  sleep(1)
end

Then(/^I should see that the photo count image is not present$/) do
  expect(@capture.vehicle_listings_page.listing_photo_count_by_vin(@vehicle.vin)).not_to be_present
end

When(/^I download photos manually and go back$/) do
  @capture.browser.driver.press_keycode(4)
end

When(/^I re\-take a photo (\d+) times$/) do |arg|
  pending
end

Then(/^I should see that the image url is valid$/) do
  pending
end

And(/^I re\-take a missing photo$/) do
  pending
end

When(/^I turn on the wifi and sync the vehicle$/) do
  pending
end

Then(/^I should see that the new photo is saved$/) do
  pending
end

When(/^I download photos manually$/) do
  pending
end

Then(/^I should see that the photo is not replaced$/) do
  pending
end

And(/^I delete a photo that was downloaded$/) do
  pending
end

When(/^I re\-take the photo that was deleted$/) do
  pending
end