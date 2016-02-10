class BaseUploader < CarrierWave::Uploader::Base
  storage :fog

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  def original_filename_without_ext
    original_filename.gsub(".#{file.extension}", "")
  end

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
end
