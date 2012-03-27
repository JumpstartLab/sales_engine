require 'csv'
require 'singleton'
require 'date'
require 'time'
require 'bigdecimal'
require 'logger'
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
    log = Logger.new("log.txt")
    ljust_default = 30
    se = SalesEngine::Database.instance
    se.load_data
    log.debug "Merchant Record Count".ljust(ljust_default) + se.merchants.count.to_s
    log.debug "Invoice Record Count".ljust(ljust_default) + se.invoices.count.to_s
    log.debug "Customer Record Count".ljust(ljust_default) + se.customers.count.to_s
    log.debug "Item Record Count".ljust(ljust_default) + se.items.count.to_s
    log.debug "Invoice Item Record Count".ljust(ljust_default) + se.invoiceitems.count.to_s
    log.debug "Transaction Record Count".ljust(ljust_default) + se.transactions.count.to_s
  end
end