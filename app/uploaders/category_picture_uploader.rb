class CategoryPictureUploader < BaseImageUploader
  def default_url
    'placeholder.png'
  end

  def store_dir
    'images/pictures'
  end

  version :medium do
    process resize_to_fill: [1000, 250]
  end
end
