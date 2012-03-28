require 'csv'
require 'bigdecimal'
require 'date'
require 'bundler'
require 'sales_engine/customer'
require 'sales_engine/invoice'
require 'sales_engine/merchant'
require 'sales_engine/invoice_item'
require 'sales_engine/item'
require 'sales_engine/transaction'
require 'sales_engine/data_store'
require 'sales_engine/search'

module SalesEngine
  def startup
    DataStore.instance
  end
end