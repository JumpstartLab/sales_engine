require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler'
Bundler.require(:default, :test)

require 'sales_engine'

SalesEngine.startup
