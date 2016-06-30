class MapIconUploader < BaseImageUploader
  def store_dir
    'images/map-icons'
  end

  def default_url
    ActionController::Base.helpers.asset_path([version_name, 'gray-icon.png'].compact.join('_'))
  end

  version :thumb do
    process resize_to_fit: [30, 40]
  end
end
