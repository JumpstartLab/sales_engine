require 'database'
require 'csv'
require 'customer'
require 'transaction'
require 'item'
require 'merchant'
require 'invoice_item'
require 'invoice'

class CSVLoader

  def initialize
    load_transactions
    load_customers
    # load_items
    # load_merchants
    # load_invoice_items
    # load_invoice
  end

  def load_transactions(filename="transactions.csv")
    puts "Loading transactions..."

    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    Database.instance.transaction_list = file.collect{ |line| Transaction.new(line) }
  end

  def load_customers(filename="customers.csv")
    puts "Loading customers..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol} )
    Database.instance.customer_list = file.collect{ |line| Customer.new(line) }
  end

  def load_items(filename="items.csv")
    puts "Loading items..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    Database.instance.item_list = file.collect{ |line| Item.new(line) }
  end

  def load_merchants(filename="merchants.csv")
    puts "Loading merchants..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    Database.instance.merchant_list = file.collect{ |line| Merchant.new(line) }
  end

  def load_invoice_items(filename="invoice_items.csv")
    puts "Loading invoice items..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    Database.instance.invoice_item_list = file.collect{ |line| InvoiceItem.new(line) }
  end

  def self.load(filename="invoices.csv")
    puts "Loading invoices..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    Database.instance.invoice_list = file.collect{ |line| Invoice.new(line) }
  end
end