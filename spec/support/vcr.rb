require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "#{::Rails.root}/spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = true #VCRブロック外のHTTP通信は許可する
  config.configure_rspec_metadata!
  config.default_cassette_options = { re_record_interval: 2.days }
  config.filter_sensitive_data('<PASSWORD>') { '<-------->' }
  # config.debug_logger = $stdout
end

