Then(/^I should see that (.*) is pre\-selected for subseries$/) do |subseries|
  4.times { @capture.vehicle_config_page.scroll_page_up }
  text = subseries.eql?('X') ? @subseries_text : subseries
  expect(@capture.vehicle_config_page.subseries_button.text).to eql text
end

Given(/^I start to enter a vehicle in capture with the VIN (.*)$/) do |vin|
  @capture.login_page.login
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

And(/^I start to add a vehicle with a single non blank subseries$/) do
  @capture.login_page.login
  record = @capture.vehicle_single_no_blank_ss
  @subseries_text = record.first.last.first
  vinpattern = record.keys[0].to_s
  vin = @capture.generate_vin_from_pattern(vinpattern)
  @vehicle = @capture.create_vehicle_with_work_order(vin)
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

When(/^I start to add a non\-VDM vehicle$/) do
  non_vdm = @capture.vehicle_non_vdm
  @vehicle = @capture.create_vehicle_with_work_order(non_vdm.vin)
  @capture.login_page.login
  @capture.add_vin_and_wo_that_decodes(@vehicle)
end

Then(/^I should see (\d+) (\w+) for trim & subseries$/) do |num_hints, s|
  @capture.vehicle_config_page.scroll_page_up_half
  @capture.set_if_not_decoded(@capture.vehicle_config_page.trim) if @capture.vehicle_config_page.trim.enabled?

  3.times { @capture.vehicle_config_page.scroll_page_up }
  @capture.vehicle_config_page.subseries_button.click
  wait_until { @capture.vehicle_config_page.vehicle_hint.present?(5) }
  text = @capture.vehicle_config_page.vehicle_hint.text
  if num_hints.to_i == 2
    text.should include(',')
  else
    text.should_not include(',')
  end
end