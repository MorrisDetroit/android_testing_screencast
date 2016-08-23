$PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
$LOAD_PATH << $PROJECT_ROOT
$LOAD_PATH << "#{$PROJECT_ROOT}/java"

ENV['TAZA_ENV'] ||= "qa"
ENV['VERSION'] ||= 'v1_0'
ENV['DEVICE'] ||= "physical" #"physical" or "emulator"

require 'rspec/expectations'
require 'appium_lib'
require 'aws-sdk'
require 'cucumber/ast'
require 'pry'
require 'selenium-webdriver'
require 'watir-webdriver'
require 'java'
require 'test-helpers/all'
require 'vinbot'
require 'watir-scroll'
require_relative 'monkey_patches/element'
require_relative 'monkey_patches/element_collection'
require 'active_record'
require 'jt400.jar'
require 'vinbot'
require 'ojdbc6.jar'
Dir["#{$PROJECT_ROOT}/lib/sites/*.rb"].each { |file| require file }
Dir["#{$PROJECT_ROOT}/services/models/*.rb"].each { |file| require file }

require_relative 'screenshots'

World(TestHelpers::Wait)
World(Screenshots)

TestHelpers::Wait.configuration do |config|
  config.wait_timeout = 20 #timeout after 30 seconds
end

physical_caps = {
    platformName: "Android",
    appPackage: "com.bdcsoftware.manheimcapture",
    appActivity: "activities.MainActivity",
    newCommandTimeout: 600,
    deviceName: "TC75"}

aim_inspect_caps = {
    platformName: "Android",
    appPackage: "com.aim.condition",
    appActivity: "activities.MainActivity",
    newCommandTimeout: 600,
    deviceName: "TC75"}

emulator_caps = {
    platformName: "Android",
    appPackage: "com.bdcsoftware.manheimcapture",
    appActivity: "activities.MainActivity",
    newCommandTimeout: 600,
    deviceName: "android",
    avd: "capture"}

capabilities = ENV['DEVICE'] == 'physical' ? aim_inspect_caps : emulator_caps

$driver = Appium::Driver.new(caps: capabilities)
Appium.promote_appium_methods Object