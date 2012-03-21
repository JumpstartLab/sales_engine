require 'simplecov'
require 'bundler'
require './lib/sales_engine'

Bundler.require

SimpleCov.start do
	add_filter "/spec/"
end

SalesEngine.startup
