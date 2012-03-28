require 'csv'
require 'sales_engine/database'
require 'sales_engine/customer'
require 'sales_engine/transaction'
require 'sales_engine/item'
require 'sales_engine/merchant'
require 'sales_engine/invoice_item'
require 'sales_engine/invoice'

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
      DB.transaction_list = file.collect do |line|
        SalesEngine::Transaction.new(line)
      end
    end

    def self.load_customers(filename="./data/customers.csv")
      puts "Loading customers..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol} )
      DB.customer_list = file.collect do |line|
        SalesEngine::Customer.new(line)
      end
    end

    def self.load_items(filename="./data/items.csv")
      puts "Loading items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      DB.item_list = file.collect do |line|
        SalesEngine::Item.new(line)
      end
    end

    def self.load_merchants(filename="./data/merchants.csv")
      puts "Loading merchants..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      DB.merchant_list = file.collect do |line|
        SalesEngine::Merchant.new(line)
      end
    end

    def self.load_invoice_items(filename="./data/invoice_items.csv")
      puts "Loading invoice items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      DB.invoice_item_list = file.collect do |line|
        SalesEngine::InvoiceItem.new(line)
      end
    end

    def self.load_invoices(filename="./data/invoices.csv")
      puts "Loading invoices..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      DB.invoice_list = file.collect do |line|
        SalesEngine::Invoice.new(line)
      end
    end
  end
end