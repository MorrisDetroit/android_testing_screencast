module Screenshots
  def take_screenshot(scenario)
    screenshots_dir = File.join(File.dirname(__FILE__), "..", "..", "screenshots")

    unless File.directory?(screenshots_dir)
      raise "!!!Cannot capture screenshots!!! Screenshot directory #{screenshots_dir} exists but isn't a directory" if File.exists? screenshots_dir
      FileUtils.mkdir_p(screenshots_dir)
    end

    screenshot_name = scenario.failed? ? 'failure_' : 'manual_validation_'
    screenshot_name << "#{scenario.location.file}:#{scenario.location.line}".gsub(/[^\w `~!@#\$%&\(\)_\-\+=\[\]\{\};',]/, '_') + ".png"
    screenshot_file = File.join(screenshots_dir, screenshot_name)
    $driver.screenshot screenshot_file
    base64_image = Base64.encode64(File.open(screenshot_file, "rb").read)
    embed("data:image/png;base64,#{base64_image}", 'image/png')
  end
end