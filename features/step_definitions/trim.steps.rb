When(/^I answer (\w+) to the trim finder question about (.*)$/) do |negative, topic|
  @capture.vehicle_config_page.scroll_page_up_half
  @capture.vehicle_config_page.run_trim_finder_button.click
  wait_until { @capture.browser.element(id: 'noButton').present? }
  @capture.browser.element(id: 'noButton').click
  wait_until { @capture.vehicle_config_page.trim.present? }
end

Then(/^I should see that the trim is "([^"]*)"$/) do |trim|
  expect(@capture.vehicle_config_page.trim.text).to eql(trim)
end