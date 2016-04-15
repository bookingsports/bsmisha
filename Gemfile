source 'https://rubygems.org'

ruby '2.2.3'

gem 'rails', '4.2.5'

# DATABASE
gem 'pg'
gem 'postgres_ext'

#MARKUP
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'haml-rails'
gem 'slim-rails'
gem 'bootstrap-sass'
gem 'simple_form'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'cocoon'
gem 'gretel'
gem 'underscore-rails'
gem 'rails-backbone', github: 'codebrew/backbone-rails'
gem 'momentjs-rails'
gem 'fullcalendar-rails'
gem 'jquery-ui-rails'
gem 'handlebars_assets'
gem 'jquery-datetimepicker-rails'
gem 'font-awesome-rails'
gem 'dropzonejs-rails'
gem 'lightbox2-rails'
gem 'ckeditor'
gem 'autoprefixer-rails'
gem 'angularjs-rails'

gem 'cancancan'

# IMAGES
gem 'fog'
gem 'carrierwave'
gem 'rmagick'

# AUTH
gem 'devise'

# LOCALIZE
gem 'rails-i18n', '~> 4.0.0'
gem 'devise-i18n'

# STATIC PAGES
gem 'high_voltage'

gem 'jbuilder'
gem 'gon', github: 'gazay/gon'
gem 'gravtastic'
gem 'gritter', '1.1.0'

# NESTED
gem 'rails_admin_nestable', '~> 0.3.2'
gem 'ancestry'

# MAPS
gem 'rails_admin_map_field', github: 'ivanzotov/rails_admin_map_field'
gem 'gmaps4rails'

gem 'friendly_id', '~> 5'
gem 'active_link_to'
gem 'ice_cube'
gem 'switch_user'
gem 'rails-observers'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'jquery-datatables-rails', '~> 3.3.0'

# ADMIN
gem 'rails_admin_history_rollback', github: 'ivanzotov/rails_admin_history_rollback'
gem 'rails_admin', github: 'ivanzotov/rails_admin', branch: 'railsmob'
gem 'paper_trail'

# SCOPES UNION
gem 'active_record_union'

# PDF RENDERING
gem 'prawn'
gem 'prawn-table'

group :development do
  gem "better_errors"
  gem "guard-bundler"
  gem "guard-rails"
  gem "guard-rspec"
  gem "hub", require: nil
  gem "quiet_assets"
  gem "rails_layout"
  gem "rb-fchange", require: false
  gem "rb-fsevent", require: false
  gem "rb-inotify", require: false
  gem "spring-commands-rspec"
  gem "letter_opener"
  gem "traceroute"
  gem "annotate"
end

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "launchy"
  gem "timecop"
  gem "selenium-webdriver"
  gem "faker", github: 'stympy/faker'
  gem "rspec-rails"
end

group :development, :test do
  gem "jasmine"
  gem "byebug"
  gem "web-console", "~> 2.0"
  gem "rubocop", require: false
  gem "spring"
  gem "railroady"
end

group :production, :staging do
  gem 'dalli'
  gem 'skylight'
  gem 'bugsnag'
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'heroku-deflater'
end
