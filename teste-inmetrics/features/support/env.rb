require 'cucumber'
require 'watir'
require 'i18n'
require 'awesome_print'
require 'faker'
require 'pry'

I18n.available_locales= [:en, :pt]

PROJETO = Dir.pwd
DIR_PAGE_OBJECTS = PROJETO + '/features/support/page_objects'
BASE_URL = (ENV['BASE_URL'] || :website).to_sym

case BROWSER = (ENV['BROWSER'] || :chrome).to_sym
when :chrome
  Selenium::WebDriver::Chrome::Service.
    driver_path = PROJETO + '/webdrivers/chromedriver.exe'
when :firefox
  Selenium::WebDriver::Firefox::Service.
    driver_path = PROJETO + '/webdrivers/geckodriver.exe'
end

FileUtils.mkdir_p(ENV['SCREENSHOT_PATH']) unless ENV['SCREENSHOT_PATH'].nil?
