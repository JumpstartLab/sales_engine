$LOAD_PATH.unshift('./')
require 'csv'
require 'customer'
require 'transaction'
require 'item'
require 'merchant'
require 'invoice_item'
require 'invoice'

class SalesEngine
  attr_accessor :customers, :transactions, :items, :merchants, :invoice_items, :invoices

  def load_customers(filename="customers.csv")
    puts "Loading customers..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol} )
    self.customers = file.collect{ |line| Customer.new(line) }
  end

  def load_transactions(filename="transactions.csv")
    puts "Loading transactions..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    self.transactions = file.collect{ |line| Transaction.new(line) }
  end

  def load_items(filename="items.csv")
    puts "Loading items..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    self.items = file.collect{ |line| Item.new(line) }
  end

  def load_merchants(filename="merchants.csv")
    puts "Loading merchants..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    self.merchants = file.collect{ |line| Merchant.new(line) }
  end

  def load_invoice_items(filename="invoice_items.csv")
    puts "Loading invoice items..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    self.invoice_items = file.collect{ |line| InvoiceItem.new(line) }
  end

  def load_invoices(filename="invoices.csv")
    puts "Loading invoices..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    self.invoices = file.collect{ |line| Invoice .new(line) }
  end
end

SE = SalesEngine.new()
SE.load_invoices
puts SE.invoices