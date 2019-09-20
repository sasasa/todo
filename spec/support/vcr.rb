require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "#{::Rails.root}/spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
  config.default_cassette_options = { re_record_interval: 2.days }
  config.filter_sensitive_data('<PASSWORD>') { '<-------->' }
end

