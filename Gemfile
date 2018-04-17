source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in grape_on_rails.gemspec
#gemspec

gem 'rack', github: 'rack/rack'
gem 'arel', github: 'rails/arel'
gem 'rails', github: 'rails/rails'
git 'https://github.com/rails/rails.git' do
  gem 'railties'
  gem 'activesupport'
  gem 'actionpack'
  gem 'activerecord', group: :test
end

# https://github.com/bundler/bundler/blob/89a8778c19269561926cea172acdcda241d26d23/lib/bundler/dependency.rb#L30-L54
@windows_platforms = [:mswin, :mingw, :x64_mingw]

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: (@windows_platforms + [:jruby])

group :development, :test do
  gem 'byebug', '~> 8.2' if RUBY_VERSION < '2.2'
  gem "pry"
  gem "pry-rails"
  gem "pry-byebug"
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec"
  gem "rspec-rails"
  gem "rspec-its"
  gem "rspec-collection_matchers"
  gem "rubocop", "~> 0.49.0", require: false
  gem "rubocop-checkstyle_formatter", require: false
end
