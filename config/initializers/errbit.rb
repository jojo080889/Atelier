Airbrake.configure do |config|
  config.api_key = ENV['AIRBRAKE_API_KEY']
  config.host    = 'discourseerrors.herokuapp.com'
  config.port    = 80
  config.secure  = config.port == 443
end
