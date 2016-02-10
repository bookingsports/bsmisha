class PictureUploader < BaseImageUploader
  def store_dir
    'images/pictures'
  end

  version :thumb do
    process resize_to_fit: [50, 50]
  end

  version :medium do
    process resize_to_fit: [400, 400]
  end

  version :small_square do
    process resize_to_fill: [200, 200]
  end
end
