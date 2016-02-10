CarrierWave.configure do |config|
  config.storage = :fog

  config.fog_credentials = {
    provider: 'AWS',
    region: 'eu-central-1',
    aws_access_key_id: Rails.application.secrets.aws_access_key_id.to_s,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key.to_s
  }

  config.fog_directory  = 'bookingsports'
  config.fog_public = true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end
