# Capybara.javascript_driver = :selenium_chrome
# Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  config.before(:each, type: :system, js: true) do
    # driven_by :selenium_chrome_headless
    # driven_by :selenium_chrome
    
    # driven_by :selenium, using: :chrome, screen_size: [1200, 1080]
    driven_by :selenium, using: :headless_chrome, screen_size: [1200, 1080]
    # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1080]
  end

end