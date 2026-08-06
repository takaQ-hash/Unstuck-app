source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.7"

gem "rails", "~> 7.2.0"
gem "pg", "~> 1.1"
gem "puma", "~> 8.0"
gem "sprockets-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "jsbundling-rails"
gem "cssbundling-rails"

# 認証
gem "devise"

# フロントエンド
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

# 日本語対応
gem "rails-i18n", "~> 7.0.0"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "pry-byebug"
  gem "faker"
  gem "factory_bot_rails"
  gem "rubocop"
  gem "rubocop-rails"
  gem "rubocop-checkstyle_formatter"
  gem "rspec-rails"
  gem "rspec_junit_formatter"
  gem "letter_opener_web"
end

group :development do
  gem "web-console"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
