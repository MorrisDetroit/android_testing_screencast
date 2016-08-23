Given(/^I am in the Settings Menu$/) do
  @capture.go_to_settings_menu
end

When(/^I click on AiM Inspect$/) do
  @capture.settings_page.aim_inspect_link.click
end

Then(/^I should see the current app version displayed$/) do
  expect(@capture.settings_page.app_version.text).to match "Build: #{/\d.\d.\d+/}"
end

Then(/^I should see the current chrome version displayed$/) do
  expect(@capture.settings_page.chrome_version.text).to match "Chrome: #{/\d+/}"
end

When(/^I select OK from the AiM Inspect popup$/) do
  @capture.settings_page.ok_button.click
end

Then(/^I should be taken to the Vehicle Listings page$/) do
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present? }
  expect(@capture.vehicle_listings_page.aim_inspect_title).to be_present
end

When(/^I click the device back button$/) do
  @capture.browser.driver.press_keycode 4
  sleep 1
end

When(/^I click on the Settings menu back arrow$/) do
  @capture.settings_page.back_arrow.click
end

When(/^I click on Upload Log$/) do
  @capture.settings_page.upload_log_link.click
end

Then(/^I should see "(.*?)" displayed in the upload log popup$/) do |message|
  wait_until { (@capture.settings_page.upload_log_message.text.match "Gathering and uploading log data#{/.+/}").eql? nil }
  expect(@capture.settings_page.upload_log_message.text).to eql message
end

When(/^I click OK in the upload log popup$/) do
  @capture.settings_page.ok_button.click
end

Then(/^I should be taken to the Settings Menu$/) do
  wait_until { @capture.settings_page.settings_header.present? }
  expect(@capture.settings_page.settings_header).to be_present
end

Given(/^I have successfully updated my password$/) do
  @capture.go_to_settings_menu("passwordchange", "123")
  @capture.change_password("123", "456")
end

Then(/^I should see the Color Equipment Values link$/) do
  expect(@capture.settings_page.color_equipment_values_link).to be_present
end

When(/^I try to sign in with my old credentials$/) do
  @capture.login_page.login("passwordchange", "123")
end

When(/^I click on Barcode Scanner Focus$/) do
  @capture.settings_page.barcode_scanner_focus_link.click
end

Then(/^I should see the following focus options$/) do |table|
  expected_values = table.raw.flatten.sort
  values = @capture.settings_page.barcode_scanner_radio_options
  found_values = []

  values.each { |value| found_values << value.text }
  expect(expected_values).to eql found_values.sort
end

When(/^I change the Barcode Scanner Focus settings$/) do
  @capture.settings_page.barcode_scanner_focus_link.click
  @capture.settings_page.barcode_scanner_radio_options.each do |option|
    if (option.attribute_value "checked").eql?("false")
      option.click
      @selected_option = option
      break
    end
  end
end

Then(/^I should see that the Barcode Scanner Focus Setting has been saved$/) do
  @capture.settings_page.barcode_scanner_focus_link.click
  expect(@selected_option.attribute_value "checked").to eql "true"
end

When(/^I click cancel on the Barcode Scanner Focus setting popup$/) do
  @capture.settings_page.barcode_scanner_focus_link.click
  @capture.settings_page.barcode_scanner_radio_options.each do |option|
    if (option.attribute_value "checked").eql?("true")
      @selected_option = option
      break
    end
  end
  @capture.settings_page.barcode_scanner_focus_cancel.click
end

Then(/^I should see that the Barcode Scanner Focus setting has not changed$/) do
  @capture.settings_page.barcode_scanner_focus_link.click
  expect(@selected_option.attribute_value "checked").to eql "true"
end

When(/^I click on Photo Overlay Duration$/) do
  @capture.settings_page.photo_overlay_duration_link.click
end

Then(/^I should see the following duration options$/) do |table|
  expected_values = table.raw.flatten.sort
  values = @capture.settings_page.photo_overlay_radio_options
  found_values = []

  values.each { |value| found_values << value.text }
  expect(expected_values).to eql found_values.sort
end

When(/^I change the Photo Overlay Duration settings$/) do
  @capture.settings_page.photo_overlay_duration_link.click
  @capture.settings_page.photo_overlay_radio_options.each do |option|
    if (option.attribute_value "checked").eql?("false")
      option.click
      @selected_option = option
      break
    end
  end
end

Then(/^I should see that the Photo Overlay Duration Setting has been saved$/) do
  @capture.settings_page.photo_overlay_duration_link.click
  expect(@selected_option.attribute_value "checked").to eql "true"
end

When(/^I click cancel on the Photo Overlay Duration setting popup$/) do
  @capture.settings_page.photo_overlay_duration_link.click
  @capture.settings_page.photo_overlay_radio_options.each do |option|
    if (option.attribute_value "checked").eql?("true")
      @selected_option = option
      break
    end
  end
  @capture.settings_page.photo_overlay_cancel.click
end

Then(/^I should see that the Photo Overlay Duration setting has not changed$/) do
  @capture.settings_page.photo_overlay_duration_link.click
  expect(@selected_option.attribute_value "checked").to eql "true"
end

When(/^I change my password using incorrect credentials$/) do
  @capture.change_password("badpassword", "newpassword")
end

When(/^I change the password without matching new passwords$/) do
  @capture.settings_page.change_password_link.click
  @capture.settings_page.old_password_field.send_keys("123")
  @capture.settings_page.new_password_field.send_keys("badpassword")
  @capture.settings_page.confirm_password_field.send_keys("badpassword1")
  @capture.settings_page.change_password_button.click
end

And(/^I log out from the Settings Menu$/) do
  @capture.browser.driver.press_keycode 4
  wait_until { @capture.main_menu.nav_menu.present? }
  @capture.main_menu.nav_menu.click
  @capture.main_menu.log_out_link.click
end

When(/^I try to sign in with my new credentials$/) do
  @capture.login_page.login("passwordchange", "456")
end

Then(/^I should see "([^"]*)" message on the change password page$/) do |arg|
  sleep 1
  pending "Manually validate the '#{arg}' message"
end

When(/^I (check|uncheck) the Color Equipment Values option$/) do |operator|
  if operator.eql? "check"
    @capture.settings_page.color_equipment_values_checkbox.click if @capture.settings_page.color_equipment_values_checkbox.attribute_value("checked").eql?("false")
  else
    @capture.settings_page.color_equipment_values_checkbox.click if @capture.settings_page.color_equipment_values_checkbox.attribute_value("checked").eql?("true")
  end
  @capture.browser.driver.press_keycode 4
  sleep 1
end

Then(/^I should( not)? see background colors on the Optional & Aftermarket tabs$/) do |negative|
  @capture.vehicle_config_page.scroll_page_up
  old = @capture.vehicle_config_page.trim.text
  @capture.vehicle_config_page.trim.click
  @capture.update_option(old)
  @capture.vehicle_menu.optional_tab.click
  sleep 1
  pending "Manually validate the background colors are#{negative} shown"
end