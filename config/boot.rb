ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

if !ENV.key?('RAILS_ENV') || ENV['RAILS_ENV'] == 'development'
  # ENV["ADMIN_NAME"]
  # ENV["ADMIN_EMAIL"]
  # ENV["ADMIN_PASSWORD"]
  # ENV["CUSTOMER_EMAIL"]
  # ENV["CUSTOMER_PASSWORD"]
  # ENV["COACH_EMAIL"]
  # ENV["COACH_PASSWORD"]
  # ENV["STADIUM_EMAIL"]
  # ENV["STADIUM_PASSWORD"]
  ENV["DEVISE_SECRET_KEY"] = 'fhkjtrrjki,mn'
  ENV["MERCHANT_ID"] = '475'
  ENV["MERCHANT_KEY"] = 'myydcyjcc'
  ENV["PAYMENT_RESULT_URL"] = "http://test.url"
  ENV["DOMAIN_NAME"] = 'example.com'
  ENV["AMOUNT_LIMIT"] = '20000'
end
