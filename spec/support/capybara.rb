Capybara.register_driver :remote_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('no-sandbox')
  options.add_argument('headless')
  options.add_argument('disable-gpu')
  options.add_argument('window-size=1680,1050')
  Capybara::Selenium::Driver.new(app, browser: :remote, url: ENV.fetch('SELENIUM_DRIVER_URL'), capabilities: options)
end

Capybara.javascript_driver = :remote_chrome
Capybara.default_driver = :remote_chrome

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :remote_chrome
    Capybara.server_host = "0.0.0.0"
    Capybara.app_host = "http://#{`hostname`.strip}:#{Capybara.server_port}"
  end
end
