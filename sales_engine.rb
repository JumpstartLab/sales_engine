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
    self.customers = load_file("customers.csv").collect {|line| Customer.new(line)}
    self.invoices = load_file("invoices.csv").collect {|line| Invoice.new(line)}   
    self.merchants = load_file("merchants.csv").collect {|line| Merchant.new(line)}
    self.items = load_file("items.csv").collect {|line| Item.new(line)}
    self.invoice_items = load_file("invoice_items.csv").collect {|line| InvoiceItem.new(line)}
    self.transactions = load_file("transactions.csv").collect {|line| Transaction.new(line)}
  end

  def load_file(filename)
    CSV.open(filename, OPTIONS)
  end
end



se = SalesEngine.new
cu = Customer.new()
#se.customers.random
#customer_instance = Customer.new(customers)
#customer_instance.random
#singleton
