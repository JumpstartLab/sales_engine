require 'csv'
require 'bigdecimal'
require 'date'
require 'time'

require 'sales_engine/database'
require 'sales_engine/customer'
require 'sales_engine/transaction'
require 'sales_engine/item'
require 'sales_engine/merchant'
require 'sales_engine/invoice_item'
require 'sales_engine/invoice'
require 'sales_engine/dynamic_finder'
require 'sales_engine/cleaner'

module SalesEngine
  class CsvLoader

    DB = SalesEngine::Database.instance

    def initialize
      load_transactions
      load_customers
      load_items
      load_merchants
      load_invoice_items
      load_invoices
    end

    def self.load_transactions(filename="./data/transactions.csv")
      puts "Loading transactions..."

      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.each do |line|
        x = SalesEngine::Transaction.new(line)
      end
    end

    def self.load_customers(filename="./data/customers.csv")
      puts "Loading customers..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol} )
      file.each do |line|
        x = SalesEngine::Customer.new(line)
      end
    end

    def self.load_items(filename="./data/items.csv")
      puts "Loading items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.each do |line|
        x = SalesEngine::Item.new(line)
      end
    end

    def self.load_merchants(filename="./data/merchants.csv")
      puts "Loading merchants..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.each do |line|
        x = SalesEngine::Merchant.new(line)
      end
    end

    def self.load_invoice_items(filename="./data/invoice_items.csv")
      puts "Loading invoice items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.each do |line|
        x = SalesEngine::InvoiceItem.new(line)
      end
    end

    def self.load_invoices(filename="./data/invoices.csv")
      puts "Loading invoices..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.each do |line|
        x = SalesEngine::Invoice.new(line)
      end
    end
  end
end