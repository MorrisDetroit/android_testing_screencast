Then /^I should be successfully logged in$/ do
  wait_until { @capture.vehicle_listings_page.aim_inspect_title.present? }
  expect(@capture.vehicle_listings_page.aim_inspect_title).to be_present
end

Then /^I should not be logged in$/ do
  expect(@capture.login_page.login_button).to be_present
end

Given /^I am logged in$/ do
  @capture.login_page.login
end

When /^I log out$/ do
  wait_until { @capture.main_menu.nav_menu.present? }
  @capture.main_menu.nav_menu.click
  @capture.main_menu.log_out_link.click
end

Then /^I should see that I am on the login screen$/ do
  expect(@capture.login_page.login_button).to be_present
end

Given(/^I log in with$/) do |table|
  values = table.rows_hash.to_param_keys
  if values[:username] == "valid" && values[:password] == "valid"
    @capture.login_page.login("captureonly", "123")
  elsif values[:username] == "valid" && values[:password] == "invalid"
    @capture.login_page.login("captureonly", "bad_pass")
  elsif values[:username] == "invalid" && values[:password] == "valid"
    @capture.login_page.login("bad_user", "123")
  elsif values[:username] == "invalid" && values[:password] == "invalid"
    @capture.login_page.login("bad_user", "bad_pass")
  elsif values[:username] == "none" && values[:password] == "none"
    @capture.login_page.login("", "")
  elsif values[:username] == "none" && values[:password] == "valid"
    @capture.login_page.login("", "123")
  elsif values[:username] == "valid" && values[:password] == "none"
    @capture.login_page.login("captureonly", "")
  end
end