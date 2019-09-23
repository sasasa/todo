# Capybara.javascript_driver = :selenium_chrome
# Capybara.javascript_driver = :selenium_chrome_headless

Capybara.server_host = Socket.ip_address_list.detect{|addr| addr.ipv4_private?}.ip_address
Capybara.server_port = 3001

Capybara.register_driver :selenium_remote do |app|
  url = "http://chrome:4444/wd/hub"
  opts = { desired_capabilities: :chrome, browser: :remote, url: url }
  driver = Capybara::Selenium::Driver.new(app, opts)
end


RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  # config.before(:each, type: :system, js: true) do
  #   # driven_by :selenium_chrome_headless
  #   # driven_by :selenium_chrome
    
  #   driven_by :selenium, using: :chrome, screen_size: [1200, 1080]
  #   # driven_by :selenium, using: :headless_chrome, screen_size: [1200, 1080]
  # end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_remote
    host! "http://#{Capybara.server_host}:#{Capybara.server_port}"
  end
end