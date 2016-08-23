module Taza
  class Browser
    def self.create_watir_webdriver(params)
      Watir::always_locate = true
      browser = Watir::Browser.new $driver.start_driver
      browser.driver.manage.timeouts.implicit_wait = 15
      browser
    end
  end
end