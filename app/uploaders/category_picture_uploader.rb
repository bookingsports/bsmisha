class CategoryPictureUploader < BaseImageUploader
  def default_url
    'placeholder_category.jpg'
  end

  def store_dir
    'images/pictures'
  end

  version :medium do
    process resize_to_fit: [480, 220]
  end
end
