require 'csv'
require 'singleton'
require 'date'
require 'time'
require 'bigdecimal'
require './lib/sales_engine/record'
require './lib/sales_engine/database'
require './lib/sales_engine/merchant'
require './lib/sales_engine/item'
require './lib/sales_engine/invoice'
require './lib/sales_engine/customer'
require './lib/sales_engine/transaction'
require './lib/sales_engine/invoice_item'


module SalesEngine
  def self.startup
    se = SalesEngine::Database.instance
    se.load_merchants_data
    puts se.merchants.count
  end
end

SalesEngine.startup