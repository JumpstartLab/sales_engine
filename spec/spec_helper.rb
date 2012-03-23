require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
end

require 'sales_engine'
require 'sales_engine/database'
require 'sales_engine/customer'
require 'sales_engine/item'
require 'sales_engine/invoice'
require 'sales_engine/transaction'
require 'sales_engine/invoice_item'
require 'sales_engine/merchant'