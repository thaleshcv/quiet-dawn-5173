source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

gem "bootsnap", ">= 1.4.2", require: false
gem "pg", ">= 0.18", "< 2.0"
gem "puma", "~> 4.1"
gem "rails", "~> 6.0.3", ">= 6.0.3.4"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 4.0"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails"
end

group :development do
  gem "capistrano", "~> 3.11"
  gem "capistrano-bundler"
  gem "capistrano-passenger", "~> 0.2.0"
  gem "capistrano-rails", "~> 1.4"
  gem "capistrano-rvm"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]

gem "annotate"
gem "devise"
gem "httparty"
gem "pundit"
gem "simple_form"
