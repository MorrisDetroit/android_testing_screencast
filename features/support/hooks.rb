Before do |scenario|
  @capture = Capture.new
  @scenario = scenario
end

After do |scenario|
  puts "VIN:#{@vin}\t WO:#{@wo}" if (@vin && @wo)
  puts "VIN:#{@vehicle.vin.to_s}\t WO:#{@vehicle.work_order.to_s}" if @vehicle
  take_screenshot scenario unless scenario.status.eql?('passed')
  @capture.close
end

After('@pwchange') do
  if @capture.vehicle_listings_page.aim_inspect_title.exists?
    @capture.main_menu.nav_menu.click
    @capture.main_menu.log_out_link.click
  end
  @capture.go_to_settings_menu("passwordchange", "456")
  @capture.change_password("456", "123")
end

Before('@multi-user-capture') do
  @capture.login_page.login
  @capture.vehicle_listings_page.inventory_filter_link.click
  @capture.inventory_filter.clear_show_only_my_vehicles
  @capture.inventory_filter.set_history_setting('Today only')
  @capture.inventory_filter.ok_button.click

  @capture.create_capture unless @capture.vehicle_listings_page.listing_created_by?("captureonly")

  unless @capture.vehicle_listings_page.listing_created_by?("auto2")
    @capture.main_menu.logout
    @capture.login_page.login("auto2", "123")
    @capture.create_capture
  end

  @capture.main_menu.logout
end

Before('@capture_db') do
  @capture_db = true
end