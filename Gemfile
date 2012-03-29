# After comma, that shows what version you want
# The purpose of a gemfile is to get all of the gems you need before
  # starting the program

# To call it, just type bundle before running

# spec folder means you use rspec

source :rubygems

group :test do
  gem "rspec"
  gem "guard"
  gem "guard-rspec"
  gem "growl"
  gem 'cane'
  gem 'reek'
  gem 'ruby_gntp'
  gem 'simplecov', :require => false, :group => :test
end

group :test, :development do
  gem 'fabrication'
end