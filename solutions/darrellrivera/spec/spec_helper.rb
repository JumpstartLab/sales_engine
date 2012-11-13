require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler'
Bundler.require(:default, :test)

require './lib/sales_engine'