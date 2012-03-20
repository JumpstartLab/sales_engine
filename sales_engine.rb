require 'csv'
require 'bundler'
require './customer'
require './invoice'
require './merchant'
require './invoice_item'
require './item'
require './transaction'

class SalesEngine
  OPTIONS = {:headers => true, :header_converters => :symbol}

  attr_accessor :customers,
                :invoices,
                :items,
                :invoice_items,
                :transactions,
                :merchants

  def initialize
    ds.data_load
  end


end



se = SalesEngine.new
#se.customers.random
#customer_instance = Customer.new(customers)
#customer_instance.random
#singleton
