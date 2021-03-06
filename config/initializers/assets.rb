# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
Rails.application.config.assets.precompile += %w( ie-spacer.gif gritter.png gritter-close.png success.png m*.png)
Rails.application.config.assets.precompile += %w( map.js draggable_map.js )
Rails.application.config.assets.precompile += %w( all_areas_schedule_view.js schedule_view.js grid_schedule_view.js one_day_schedule_view.js )
Rails.application.config.assets.precompile += %w( markerclusterer.js )
Rails.application.config.assets.precompile += %w( scheduler.js )
Rails.application.config.assets.precompile += %w( lightbox/* )
Rails.application.config.assets.precompile += %w( ckeditor/* )
Rails.application.config.assets.precompile += %w( jQuery.print.js )