$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless
  $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
require 'csv'
require 'singleton'
require 'date'
require 'time'
require 'bigdecimal'
require 'logger'
require 'utilities'
require 'sales_engine/record'
require 'sales_engine/database'
require 'sales_engine/merchant'
require 'sales_engine/item'
require 'sales_engine/invoice'
require 'sales_engine/customer'
require 'sales_engine/transaction'
require 'sales_engine/invoice_item'

module SalesEngine
  DATABASE = SalesEngine::Database.instance

  def self.startup
    DATABASE.load_data
  end
end