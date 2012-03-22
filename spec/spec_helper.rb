require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require './lib/sales_engine'
require './lib/sales_engine/database'
require './lib/sales_engine/customer'
require './lib/sales_engine/item'
require './lib/sales_engine/invoice'
require './lib/sales_engine/transaction'
require './lib/sales_engine/invoice_item'
require './lib/sales_engine/merchant'