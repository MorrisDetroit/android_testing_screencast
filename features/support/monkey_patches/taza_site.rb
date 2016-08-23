module Taza
  class Site

    def initialize(params={}, &block)
      @module_name = self.class.parent.to_s
      @class_name = self.class.to_s.split("::").last
      define_site_pages
      define_flows
      config = Settings.config(@class_name)
      if params[:browser]
        @browser = params[:browser]
      else
        @browser = Browser.create(config)
        @i_created_browser = true
      end
      @browser.goto(params[:url] || config[:url]) unless params[:url] == false || config[:url] == false
      execute_block_and_close_browser(browser, &block) if block_given?
    end
  end
end
