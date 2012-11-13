require 'bundler'
Bundler.require(:default, :test)
require 'simplecov'
require 'date'
SimpleCov.start do
  add_filter "/spec/"
end

require 'sales_engine'