Then(/^I should see that the vehicle configuration is populated from (Capture DB|VDM|Chrome DB)$/) do |source|
  if source.eql? "Capture DB"
    expect(@capture.vehicle_config_page.flash_message.text).to eql "Previous Capture data, please verify."
  elsif source.eql? "VDM"
    expect(@capture.vehicle_config_page.flash_message.text).to eql "This is a VDM decoded vehicle. Year, Make, Model and Trim changes are not allowed."
  elsif source.eql? "Chrome DB"
    stripped_text = @capture.vehicle_listings_page.workorder_warning.text.gsub(/[[:punct:]]/, "")
    expect(stripped_text).to eql "The VIN doesnt have a previous record Please verify it is accurate and select Add as New to Continue"
    @capture.vehicle_listings_page.add_as_new.click
  end

end

And(/^I enter a VIN that is$/) do |table|
  data = table.raw.flatten
  in_capture_db = data[0].eql?("in Capture DB")
  in_vdm = data[1].eql?("in VDM")

  if in_capture_db
    recent_vehicle_and_wo = @capture.wo_and_vin_from_capture_within_last_3_months
    vin = recent_vehicle_and_wo[:vin]
  elsif in_vdm
    record = VehicleBase.select(:vin).first
    vin = record.last.vin
  else
    @vehicle = @capture.create_vehicle_with_work_order
    vin = @vehicle.vin
  end
  @capture.vehicle_listings_page.vin.send_keys vin
  @capture.hide_keyboard_if_present
  @capture.vehicle_listings_page.workorder_search.click
end

When(/^I enter a work order that is in the Capture DB, in IFS, within the past 3 months$/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @capture.login_page.login
  @capture.vehicle_listings_page.add_vehicle_button.click
  recent_vehicle = @capture.wo_and_vin_from_capture_within_last_3_months
  @wo = recent_vehicle[:work_order]
  @capture.vehicle_listings_page.workorder_entry.send_keys @wo
  @capture.vehicle_listings_page.workorder_search.click
  @vin = @capture.vehicle_config_page.vin.text
end

When(/^I enter a work order that is in the Capture DB, in IFS, not within the past 3 months$/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @capture.login_page.login
  @capture.vehicle_listings_page.add_vehicle_button.click
  old_vehicle = @capture.wo_and_vin_from_capture_over_3_months_old
  @wo = old_vehicle[:work_order]
  @capture.vehicle_listings_page.workorder_entry.send_keys @wo
  @capture.vehicle_listings_page.workorder_search.click
  @vin = old_vehicle[:vin]

end

Then(/^I should see that the mileage is (not )?populated$/) do |operator|
  wait_until { @capture.vehicle_config_page.vin.exists? }
  4.times { @capture.vehicle_config_page.scroll_page_up }
  if operator.eql? "not "
    expect(@capture.vehicle_config_page.mileage.text.to_i).to eql 0
  else
    expect(@capture.vehicle_config_page.mileage.text.to_i).to be > 0
  end
end

When(/^I update the vehicle mileage units to bring record to device$/) do
  old = @capture.vehicle_config_page.mileage_unit_of_measure.text
  @capture.vehicle_config_page.mileage_unit_of_measure.click
  @capture.update_option(old)
  sleep 1
end

And(/^I should see that photos are (not )?attached$/) do |operator|
  @capture.browser.driver.press_keycode 4
  sleep 1
  @wo = @vehicle.work_order if @vehicle
  if operator == "not "
    expect(@capture.vehicle_listings_page.listing_photo_count_by_wo(@wo).present?).to be false
  else
    expect(@capture.vehicle_listings_page.listing_photo_count_by_wo(@wo).text).to eql "7"
  end
end

When(/^I enter a work order that is not in the Capture DB and not in IFS$/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @capture.login_page.login
  @capture.vehicle_listings_page.add_vehicle_button.click
  @wo = @capture.vehicle_listings_page.fake_wo_number
  @capture.vehicle_listings_page.workorder_entry.send_keys @wo
  @capture.vehicle_listings_page.workorder_search.click
  expect(@capture.vehicle_listings_page.workorder_warning.text).to eql "WO was not found. Please verify the WO and search again or enter/scan the VIN to begin"
end

When(/^I enter a work order that is not in the Capture DB and in IFS with a VIN that is$/) do |table|
  pending 'Need access to AiM capture db.' if @capture_db
  @capture.login_page.login
  vin_values = table.rows_hash.to_param_keys
  @capture.vehicle_listings_page.add_vehicle_button.click
  if vin_values[:Capture] == "absent" && vin_values[:VDM] == "absent"
    @vehicle = @capture.create_vehicle_with_work_order
    #TODO I dont like the passive sleep. We need to find the query that can replace this
    sleep 10
  elsif vin_values[:Capture] == "present" && vin_values[:VDM] == "absent"
    @vehicle = @capture.vehicle_from_capture_not_vdm
    sleep 10
  elsif vin_values[:Capture] == "absent" && vin_values[:VDM] == "present"
    @vehicle = @capture.vehicle_from_vdm_not_capture
    sleep 10
  end

  auth_response = OauthApi.oauth_post
  response = HTTParty.get("https://integration1.api.manheim.com/consignments/id/legacy/QLM1/work_order_number/#{@vehicle.work_order}", headers: {'Authorization' => "Bearer #{auth_response['accessToken']}"})
  pending("Work order was not found in IFS!") unless response.code == 200

  @wo = @vehicle.work_order
  @capture.vehicle_listings_page.workorder_entry.send_keys @wo
  @capture.vehicle_listings_page.workorder_search.click
end