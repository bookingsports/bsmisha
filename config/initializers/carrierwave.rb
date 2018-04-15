CarrierWave.configure do |config|


  config.fog_credentials = {
    provider: 'AWS',
    region: 'eu-west-2',
    aws_access_key_id: Rails.application.secrets.aws_access_key_id.to_s,
    aws_secret_access_key: Rails.application.secrets.aws_secret_access_key.to_s
  }

  config.storage = :fog

  config.fog_directory  = 'bssports'
  config.fog_public = false
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
end
