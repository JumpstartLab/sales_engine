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
      file.each do |line|
        x = SalesEngine::Transaction.new(line)
        DB.transaction_list << x
        DB.transaction_hash[ x.id ] = x
      end
    end

    def self.load_customers(filename="./data/customers.csv")
      puts "Loading customers..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol} )
      file.collect do |line|
        x = SalesEngine::Customer.new(line)
        DB.customer_list << x
        DB.customer_hash[ x.id ] = x
      end
    end

    def self.load_items(filename="./data/items.csv")
      puts "Loading items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.collect do |line|
        x = SalesEngine::Item.new(line)
        DB.item_list << x
        DB.item_hash[ x.id ] = x
      end
    end

    def self.load_merchants(filename="./data/merchants.csv")
      puts "Loading merchants..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.collect do |line|
        x = SalesEngine::Merchant.new(line)
        DB.merchant_list << x
        DB.merchant_hash[ x.id ] = x
      end
    end

    def self.load_invoice_items(filename="./data/invoice_items.csv")
      puts "Loading invoice items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.collect do |line|
        x = SalesEngine::InvoiceItem.new(line)
        DB.invoice_item_list << x
        DB.invoice_item_hash[ x.id ] = x
      end
    end

    def self.load_invoices(filename="./data/invoices.csv")
      puts "Loading invoices..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.collect do |line|
        x = SalesEngine::Invoice.new(line)
        DB.invoice_list << x
        DB.invoice_hash[ x.id ] = x
      end
    end
  end
end