$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__))) unless $LOAD_PATH.include?(File.expand_path(File.dirname(__FILE__)))
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
  LOG = Logger.new("log.txt")
  
  def self.startup
    ljust_default = 30
    se = SalesEngine::Database.instance
    se.load_data
    LOG.debug "Merchant Record Count".ljust(ljust_default) + se.merchants.count.to_s
    LOG.debug "Invoice Record Count".ljust(ljust_default) + se.invoices.count.to_s
    LOG.debug "Customer Record Count".ljust(ljust_default) + se.customers.count.to_s
    LOG.debug "Item Record Count".ljust(ljust_default) + se.items.count.to_s
    LOG.debug "Invoice Item Record Count".ljust(ljust_default) + se.invoiceitems.count.to_s
    LOG.debug "Transaction Record Count".ljust(ljust_default) + se.transactions.count.to_s
  end
end