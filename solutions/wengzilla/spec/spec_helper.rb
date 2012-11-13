require 'bundler'
Bundler.require

require 'simplecov'
SimpleCov.start

#Eventually just require the main file and all the other files
# in lib will get required

require 'sales_engine.rb'
require 'sales_engine/customer.rb'
require 'sales_engine/item.rb'
require 'sales_engine/invoice.rb'
require 'sales_engine/transaction.rb'
require 'sales_engine/merchant.rb'
require 'sales_engine/invoice_item.rb'
