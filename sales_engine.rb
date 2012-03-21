require 'csv'
require 'bundler'
require './customer'
require './invoice'
require './merchant'
require './invoice_item'
require './item'
require './transaction'
require './data_store'

class SalesEngine

  attr_accessor :customers,
                :invoices,
                :items,
                :invoice_items,
                :transactions,
                :merchants

  def initialize
    data = DataStore.new
  end

  def printtest
    printf INVOICES[0]
  end

end



se = SalesEngine.new
Customer.random
Customer.find_by_cust_id(3)
Customer.find_all_by_cust_id(3)
#se.customers.random
#customer_instance = Customer.new(customers)
#customer_instance.random
#singleton
