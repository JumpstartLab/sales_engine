require 'simplecov'
SimpleCov.start do
	add_filter "/spec"
end

require './merchant'
require './invoice'
require './item'
require './sales_engine'
require './invoice_item'
require './transaction'
require './customer'