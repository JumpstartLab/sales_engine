require 'bundler'
Bundler.require

require 'simplecov'
SimpleCov.start

#Eventually just require the main file and all the other files
# in lib will get required

require 'runner.rb'
require 'sales_engine.rb'
require 'customer.rb'
require 'item.rb'
require 'invoice.rb'
require 'transaction.rb'
require 'merchant.rb'
require 'invoice_item.rb'
