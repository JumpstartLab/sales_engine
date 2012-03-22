require 'simplecov'
SimpleCov.start do
	add_filter "/spec/"
end

require 'bundler'
Bundler.require

require './sales_engine'
SalesEngine.startup
