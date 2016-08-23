Given(/^I start to manually add a new vehicle$/) do
  @vehicle = @capture.create_vehicle_with_work_order

  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

When(/^The Inoperable box is checked for mileage$/) do
  4.times { @capture.vehicle_config_page.scroll_page_up }
  @capture.vehicle_config_page.odometer_inoperable.click
  @capture.hide_keyboard_if_present
end

Then(/^I should see that I can not enter mileage for the vehicle$/) do
  expect(@capture.vehicle_config_page.mileage).not_to be_enabled
end

When(/^I enter mileage$/) do
  4.times { @capture.vehicle_config_page.scroll_page_up }
  @capture.vehicle_config_page.mileage.send_keys "1234"
  @capture.hide_keyboard_if_present
end

Then(/^I should be able to pick between Miles and Kilometers$/) do
  expect(@capture.vehicle_config_page.mileage_units).to eql ["Kilometers", "Miles"]
end

Given(/^I enter a vehicle vin that decodes$/) do
  @vehicle = @capture.create_vehicle_with_work_order

  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see that the Year, Make, and Model are populated$/) do
  expect(@capture.vehicle_config_page.year.text).not_to eql "Select Year"
  expect(@capture.vehicle_config_page.make.text).not_to eql "Select Make"
  expect(@capture.vehicle_config_page.model.text).not_to eql "Select Model"
end

Then(/^I should see that the following fields are required$/) do |table|
  2.times { @capture.vehicle_config_page.scroll_page_up }
  take_screenshot(@scenario)
  @capture.vehicle_config_page.scroll_page_up
  pending('Manually validate required fields')
end

Given(/^I have a vehicle entered through capture$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @options = @capture.set_random_options
  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

Given(/^I have a pre-1992 vehicle entered through capture$/) do
  @capture.login_page.login
  @vehicle = @capture.create_pre_92_vehicle_with_work_order
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @options = @capture.set_random_options
  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

When(/^I update the interior color$/) do
  wait_until(timeout: 120, interval: 2) { PFVehicle.where(work_order_number: @vehicle.work_order).first.sintco.strip != "" }
  @old_int_color = PFVehicle.where(work_order_number: @vehicle.work_order).first.sintco
  @capture.update_interior_color(@vehicle.vin)
  @capture.browser.driver.press_keycode(4)
end

Then(/^I should see the interior color updated in the PF_Vehicle table \#SINTCO$/) do
  wait_until(timeout: 120, interval: 2) { PFVehicle.where(work_order_number: @vehicle.work_order).first.sintco.strip != @old_int_color }
  expect(PFVehicle.where(work_order_number: @vehicle.work_order).first.sintco).not_to eql @old_int_color
end

When(/^I update the exterior color$/) do
  wait_until(timeout: 120, interval: 2) { PFVehicle.where(work_order_number: @vehicle.work_order).first.scolor.strip != "" }
  @old_ext_color = PFVehicle.where(work_order_number: @vehicle.work_order).first.scolor
  @capture.update_exterior_color(@vehicle.vin)
  @capture.browser.driver.press_keycode(4)
end

Then(/^I should see the exterior color updated in the PF_Vehicle table \#SCOLOR$/) do
  wait_until(timeout: 120, interval: 2) { PFVehicle.where(work_order_number: @vehicle.work_order).first.scolor != @old_ext_color }
  expect(PFVehicle.where(work_order_number: @vehicle.work_order).first.scolor).not_to eql @old_ext_color
end

Given(/^I enter a vehicle in capture that decodes to a single (US|CA) trim$/) do |country|
  @capture.login_page.login
  # TODO: Replace with query for single trim
  country.eql?('CA') ? vin = '2HHFD559080000000' : pending('Need a vin for single US trim')

  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.vehicle_config_page.scroll_page_up_half
end

Then(/^I should see that the trim is populated$/) do
  expect(@capture.vehicle_config_page.trim.text).not_to eql "Select Trim"
end

Given(/^I enter a vehicle in capture that decodes to a multiple trims$/) do
  # TODO: Replace with query for multiple trims
  @capture.login_page.login
  @vehicle = @capture.create_vehicle_with_work_order "1FA6P8CF1F1111111"
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see that the Run Trim Finder button is enabled/) do
  @capture.vehicle_config_page.scroll_page_up_half
  expect(@capture.vehicle_config_page.run_trim_finder_button).to be_enabled
end

Then(/^I should see that the Run Trim Finder button is not enabled/) do
  expect(@capture.vehicle_config_page.run_trim_finder_button).not_to be_enabled
end

Given(/^I partially enter a vehicle into capture$/) do
  @capture.login_page.login
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @capture.browser.driver.press_keycode 4
end

When(/^I set the int and ext colors, and then update the trim$/) do
  @capture.vehicle_config_page.scroll_page_up_half
  old_trim = @capture.vehicle_config_page.trim.text
  @capture.vehicle_config_page.trim.click
  @capture.update_option(old_trim)
  new_trim = @capture.vehicle_config_page.trim.text

  2.times { @capture.vehicle_config_page.scroll_page_up }
  old_ext_color = @capture.vehicle_config_page.exterior_color.text
  @capture.vehicle_config_page.exterior_color.click
  @capture.update_option(old_ext_color)

  old_int_color = @capture.vehicle_config_page.interior_color.text
  @capture.vehicle_config_page.interior_color.click
  @capture.update_option(old_int_color)

  2.times { @capture.vehicle_config_page.scroll_page_down }
  @capture.vehicle_config_page.trim.click
  @capture.update_option(new_trim)

  2.times { @capture.vehicle_config_page.scroll_page_up }
  @found_ext_color = @capture.vehicle_config_page.exterior_color.text
  @found_int_color = @capture.vehicle_config_page.interior_color.text
end

Then(/^I should see that the int and ext colors are no longer populated$/) do
  expect(@found_int_color).to eql("Select Interior Color")
  expect(@found_ext_color).to eql("Select Exterior Color")
end

When(/^I select the load additional engines option$/) do
  @capture.vehicle_config_page.load_engines_menu.click
  @capture.vehicle_config_page.load_engines_link.click
end

Then(/^I should see the following engine options:$/) do |table|
  @capture.vehicle_config_page.scroll_page_up_half
  @capture.vehicle_config_page.engine_spinner.click
  expected_values = table.raw.flatten.sort
  found_values = []
  4.times do
    elements = @capture.vehicle_config_page.text_fields
    @capture.vehicle_config_page.scroll_page_down(elements)
  end
  4.times do
    values = @capture.vehicle_config_page.text_fields
    values.each { |value| found_values << value.text.downcase unless value.text.eql? "" }
    @capture.vehicle_config_page.scroll_page_up(values)
  end
  expected_values.each { |value| value.downcase! }
  expect(found_values.uniq.sort).to eql expected_values
end

When(/^I update the trim$/) do
  pending
end

Then(/^I should see that the trim is updated in the PF_Vehicle table$/) do
  pending
end

Then(/^I should see that the vehicle is updated in the PF_Vehicle table$/) do
  wait_until(timeout: 120, interval: 1) do
    PFVehicle.where(work_order_number: @vehicle.work_order).first.make.downcase.eql?(@vehicle.make.downcase)
  end

  captured_vehicle = PFVehicle.where(work_order_number: @vehicle.work_order).first
  expect(captured_vehicle.vin).to eql @vehicle.vin
  expect(captured_vehicle.make.downcase).to eql @vehicle.make.downcase
  expect(captured_vehicle.year.to_s).to eql @vehicle.year.to_s
end

Given(/^I enter a vehicle that has only one roof and wheel type available$/) do
  pending('Manually validate single roof and wheel type')
end

Then(/^I should see that the wheel and roof types are populated$/) do
  pending('Manually validate single roof and wheel type')
end

Then(/^I should see the incomplete vehicle warning icon$/) do
  sleep 1
  pending('Manually validate the incomplete vehicle warning icon displayed')
end

Then(/^I should see the green success icon$/) do
  sleep 1
  pending('Manually validate the green success icon displayed')
end

Given(/^I enter a vehicle in capture that has US and Canada trims/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @capture.login_page.login
  # TODO: Replace with query
  vin = "2G1FF3D33F1234567"
  @vehicle = @capture.create_vehicle_with_work_order vin
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see the vehicle has trim options for US and CA$/) do
  Scroll.to_element(@capture.vehicle_config_page.trim)
  @capture.vehicle_config_page.trim.click

  expected_values = ["2dr Conv LT w/2LT", "2dr Conv LT w/2LT (CAN)"].map(&:downcase)
  found_values = []
  values = @capture.vehicle_config_page.text_fields
  values.each { |value| found_values << value.text.downcase unless value.text.eql?("") }

  expect(found_values.uniq.sort).to eql expected_values
end

When(/^I use the Trim Finder to find a trim$/) do
  Scroll.to_element(@capture.vehicle_config_page.run_trim_finder_button)
  @capture.vehicle_config_page.run_trim_finder_button.click
  wait_until { @capture.vehicle_config_page.yes_button.present? }
  @capture.vehicle_config_page.yes_button.click while @capture.vehicle_config_page.yes_button.present?
end

Then(/^I should see that the subseries matches the csv file$/) do
  3.times { @capture.vehicle_config_page.scroll_page_up }
  @capture.vehicle_config_page.subseries_button.click

  expected_values = []
  @record.values[0].each do |x|
    x.eql?('{blanks}') ? expected_values << '(none)' : expected_values << x.downcase
  end

  found_values = []
  values = @capture.vehicle_config_page.text_fields
  values.each { |value| found_values << value.text.downcase unless value.text.eql?("") }

  expect(found_values.uniq.sort).to eql expected_values
end

When(/^I decode a vin that has a (SUV|Truck|Van) body style$/) do |body_style|
  case body_style
    when "SUV"
      desc = "Sport Utility"
    when "Truck"
      desc = "Crew Cab Pickup"
    when "Van"
      desc = "Full-size Cargo Van"
  end
  record = @capture.vin_body_style(desc)
  vin = record.items.first['vin']
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see that the additional tab has (SUV|Truck|Van) options$/) do |body_type|
  @capture.vehicle_menu.scroll_menu_left
  wait_until { @capture.vehicle_menu.additional_tab.present? }
  @capture.vehicle_menu.additional_tab.click
  sleep 2
  options = []
  records = @capture.additional_options(body_type)
  records.items.each do |record|
    options << record['description']
  end
  options.sort!

  wait_until { @capture.vehicle_options_page.vertical_scroll.present? }
  case body_type
    when "SUV"
      4.times { |x| expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled }

      @capture.vehicle_options_page.scroll_page_up
      for x in 4..5
        expect(Scroll.to_element(@capture.browser.element(text: /#{options[x]}/))).to be_enabled
      end

      @capture.vehicle_options_page.scroll_page_up
      for x in 6..7
        expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled
      end
    when "Truck"
      3.times { |x| expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled }

      @capture.vehicle_options_page.scroll_page_up
      for x in 3..5
        expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled
      end

      2.times { @capture.vehicle_options_page.scroll_page_up }

      @capture.vehicle_options_page.scroll_page_up_half
      for x in 6..8
        expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled
      end
      expect(Scroll.to_element(@capture.browser.element(text: /#{options[9]}/))).to be_enabled
    when "Van"
      expect(@capture.browser.element(text: /#{options[0]}/)).to be_enabled

      @capture.vehicle_options_page.scroll_page_up
      for x in 1..4
        expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled
      end

      @capture.vehicle_options_page.scroll_page_up
      for x in 5..10
        expect(@capture.browser.element(text: /#{options[x]}/)).to be_enabled
      end

      2.times { @capture.vehicle_options_page.scroll_page_up }
      expect(@capture.browser.element(text: /#{options[11]}/)).to be_enabled
  end
end

And(/^I add a vehicle with pre\-defined subseries$/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @record = @capture.vehicle_single_no_blank_ss
  @subseries_text = @record.values[0][0]

  vinpattern = @record.keys[0].to_s
  vin = @capture.generate_vin_from_pattern(vinpattern)

  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @options = @capture.set_random_options
  @capture.vehicle_config_page.scroll_page_up
  @capture.hide_keyboard_if_present
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

Then(/^I should see the trim and subseries values in the JSON$/) do
  wait_until { !@capture.get_capture_json(@vehicle.vin).nil? }
  json = @capture.get_capture_json @vehicle.vin
  expect(json['trim']).to eql @options[:trim].gsub(' (CAN)', '')
  expect(json['subseries']).to eql @options[:subseries]
end

Then(/^I should see country is (US|CA) in the JSON$/) do |country|
  wait_until { !@capture.get_capture_json(@vehicle.vin).nil? }
  json = @capture.get_capture_json @vehicle.vin
  expect(json['country']).to eql country
end

Then(/^I should see the user defined subseries flag is (\d+) in the JSON$/) do |flag|
  wait_until { !@capture.get_capture_json(@vehicle.vin).nil? }
  json = @capture.get_capture_json @vehicle.vin
  expect(json['user_defined_subseries']).to eql flag
end

And(/^I add a vehicle with user defined subseries$/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @options = @capture.set_random_options

  @capture.vehicle_config_page.subseries_button.click
  @capture.vehicle_config_page.subseries_field.send_keys "USER"
  @capture.hide_keyboard_if_present
  @capture.vehicle_config_page.ok_button.click
  wait_until { @capture.vehicle_config_page.roof_type.enabled? }
  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

And(/^I complete the capture with (US|CA) trim$/) do |country|
  @capture.vehicle_config_page.scroll_page_up_half
  @capture.vehicle_config_page.trim.click
  elements = @capture.vehicle_config_page.text_fields
  (country.eql? "US") ? elements[1].click : elements[2].click
  @options = @capture.set_random_options
  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

Then(/^I should see that the subseries is saved to PF_Vehicle$/) do
  wait_until(timeout: 120, interval: 2) { PFVehicle.where(work_order_number: @vehicle.work_order).first.ssubse.strip.eql? @options[:subseries] }
  expect(PFVehicle.where(work_order_number: @vehicle.work_order).first.ssubse.strip).to eql @options[:subseries]
end

When(/^I finish the capture with subseries (.*)$/) do |subseries|
  @options = @capture.set_random_options
  @capture.vehicle_config_page.subseries_button.click
  @capture.browser.element(text: /#{subseries}/).click
  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

And(/^I start to add a vehicle with a single blank subseries$/) do
  pending 'Need access to AiM capture db.' if @capture_db
  @record = @capture.vehicle_single_blank_ss
  vinpattern = @record.keys[0].to_s
  vin = @capture.generate_vin_from_pattern(vinpattern)
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

And(/^I start to add a vehicle with multiple subseries including blank$/) do
  @record = @capture.vehicle_multi_blank_ss
  vinpattern = @record.keys[0].to_s
  vin = @capture.generate_vin_from_pattern(vinpattern)
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Given(/^I start to add a vehicle with multiple subseries$/) do
  @record = @capture.vehicle_random_multi_ss
  vinpattern = @record.keys[0].to_s
  vin = @capture.generate_vin_from_pattern(vinpattern)
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see that (\s+) is pre\-selected for subseries$/) do
  pending
end

Then(/^I should see that "X" is the subseries is pre\-selected$/) do
  pending
end

And(/^I start to add a BMW VDM vehicle$/) do
  record = VehicleBase.where(make: 'BMW').first
  vin = record.vin
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see the trim hint$/) do
  pending
end

Given(/^I start to add a vehicle with a vin that decodes to multiple models$/) do
  @vehicle = @capture.create_vehicle_with_work_order("KMHGN4JE8GU136148")
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Given(/^I enter a vehicle in capture that decodes to multiple models$/) do
  #TODO Replace with query
  vin = "KMHGN4JE8GU136148"

  # vins = []
  # CSV.foreach('./data/subseries_data.csv') do |row|
  #   vins << row.first.strip.to_sym
  # end

  # vinpattern = vins.sample.to_s
  # vin = @capture.generate_vin_from_pattern(vinpattern)

  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @vehicle.year = @capture.vehicle_config_page.year.text
  @vehicle.make = @capture.vehicle_config_page.make.text

  @capture.vehicle_config_page.scroll_page_up_half
  text = @capture.vehicle_config_page.trim.text
  @capture.vehicle_config_page.trim.click
  @capture.update_option(text)

  @capture.vehicle_config_page.scroll_page_down_half
  @options = @capture.set_random_options

  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.mileage.send_keys "12345"
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

Given(/^I select random options$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
  @options = @capture.set_random_options
end

And(/^I add a vehicle with inoperable odometer$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)

  @vehicle.vin = @capture.vehicle_config_page.vin.text
  @vehicle.make = @capture.vehicle_config_page.make.text
  @vehicle.year = @capture.vehicle_config_page.year.text
  @options = @capture.set_random_options

  @capture.vehicle_config_page.scroll_page_up
  @capture.vehicle_config_page.odometer_inoperable.click
  @capture.hide_keyboard_if_present
  @capture.add_all_default_pictures
  wait_until { @capture.summary_page.finish_button.present?(10) }
  @capture.summary_page.finish_button.click
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present?(10) }
  sleep(15)
end

And(/^I delete the vehicle from the inventory list$/) do
  @capture.vehicle_listings_page.delete_listing @vehicle.work_order
end

Then(/^I should see that the mileage is (\d+)$/) do |mileage|
  4.times { @capture.vehicle_config_page.scroll_page_up }
  expect(@capture.vehicle_config_page.mileage.text).to eql mileage
  @capture.browser.driver.press_keycode 4
end

When(/^I turn (on|off) the wifi$/) do |option|
  @capture.set_wifi(option.to_sym)
end

When(/^I start to enter a vehicle with the same vin$/) do
  @new_vehicle = @capture.create_vehicle_with_work_order @vehicle.vin
  @capture.add_vin_and_wo_that_decodes(@new_vehicle)
end

And(/^I start to add a previously captured vehicle$/) do
  @vehicle = @capture.create_vehicle_with_work_order
  @vehicle.vin = @capture.vins_from_capture.sample
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

And(/^I should see that the new record in PF_Vehicle has previous capture data$/) do
  wait_until(timeout: 120, interval: 2) { !PFVehicle.where(work_order_number: @new_vehicle.work_order).empty? }
  captured_vehicle = PFVehicle.where(work_order_number: @new_vehicle.work_order).first
  expect(captured_vehicle.vin).to eql @vehicle.vin
  expect(captured_vehicle.make.downcase).to eql @vehicle.make.downcase
  expect(captured_vehicle.year.to_s).to eql @vehicle.year.to_s
end

When(/^I scroll trim into view$/) do
  @capture.vehicle_config_page.scroll_page_up
end