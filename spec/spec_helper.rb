require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler'
Bundler.require

require './lib/sales_engine'
SalesEngine.startup

require 'date'
require 'fabrication'
require 'faker'