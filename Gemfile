source 'https://rubygems.org'

ruby '3.3.0'
gem 'rails', '7.1.3.4'

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'devise', '~> 4.9'
gem 'image_processing', '~> 1.2'
gem 'inline_svg', '~> 1.9'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'kredis'
gem 'pg', '~> 1.1'
gem 'pg_search', '~> 2.3'
gem 'puma', '>= 5.0'
gem 'redis', '>= 4.0.1'
gem 'sidekiq', '~> 7.2'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'stimulus_reflex', '~> 3.5', '>= 3.5.1'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[ windows jruby ]

group :development, :test do
  gem 'debug', platforms: %i[ mri windows ]
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.3'
  gem 'faker'
  gem 'rspec-rails', '~> 6.1', '>= 6.1.2'
end

group :development do
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem 'rack-mini-profiler'

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem 'spring'

  gem 'letter_opener_web', '~> 3.0'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'shoulda-matchers', '~> 6.2'
  gem 'webdrivers', '~> 5.0', require: false
end