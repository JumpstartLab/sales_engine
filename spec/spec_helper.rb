require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'bundler'
Bundler.require(:default, :test)

require './lib/sales_engine/database'
require './lib/sales_engine/merchant'
require './lib/sales_engine/item'
require './lib/sales_engine/invoice'
require './lib/sales_engine/customer'
require './lib/sales_engine/transaction'
require './lib/sales_engine/invoice_item'