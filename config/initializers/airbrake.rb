Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.use_system_ssl_cert_chain = true
  config.secure = true
  config.rescue_rake_exceptions = true
end
