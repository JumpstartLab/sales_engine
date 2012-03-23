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

    def initialize
      load_transactions
      load_customers
      load_items
      load_merchants
      load_invoice_items
      load_invoices
    end

    def load_transactions(filename="./data/transactions.csv")
      puts "Loading transactions..."

      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      SalesEngine::Database.instance.transaction_list = file.collect{ |line| SalesEngine::Transaction.new(line) }
    end

    def load_customers(filename="./data/customers.csv")
      puts "Loading customers..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol} )
      SalesEngine::Database.instance.customer_list = file.collect{ |line| SalesEngine::Customer.new(line) }
    end

    def load_items(filename="./data/items.csv")
      puts "Loading items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      SalesEngine::Database.instance.item_list = file.collect{ |line| SalesEngine::Item.new(line) }
    end

    def load_merchants(filename="./data/merchants.csv")
      puts "Loading merchants..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      SalesEngine::Database.instance.merchant_list = file.collect{ |line| SalesEngine::Merchant.new(line) }
    end

    def load_invoice_items(filename="./data/invoice_items.csv")
      puts "Loading invoice items..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      SalesEngine::Database.instance.invoice_item_list = file.collect{ |line| SalesEngine::InvoiceItem.new(line) }
    end

    def load_invoices(filename="./data/invoices.csv")
      puts "Loading invoices..."
      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      SalesEngine::Database.instance.invoice_list = file.collect{ |line| SalesEngine::Invoice.new(line) }
    end
  end
end