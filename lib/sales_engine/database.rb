require 'csv'
require 'singleton'
require 'sales_engine/merchant'
require 'sales_engine/invoice'
require 'sales_engine/customer'
require 'sales_engine/invoice_item'
require 'sales_engine/transaction'

class SalesEngine
  class Database
    include Singleton

    def initialize
      load_merchants
      load_items
      load_invoices
      load_customers
      load_invoice_items
      load_transactions
    end

    def load(filename)
      CSV.open(filename, :headers => true, :header_converters => :symbol)
    end

    def load_merchants
      @merchants = []
      data = load("data/merchants.csv")
      data.each do |line|
        @merchants << Merchant.new(line)
      end
      puts "Merchants loaded"
    end

    def merchants
      @merchants
    end

    def load_items
      @items = []
      data = load("data/items.csv")
      data.each do |line|
        @items << Item.new(line)
      end
      puts "Items Loaded"
    end
 
    def items
      @items
    end

    def items=(input)
      @items = input
    end

    def load_invoices
      @invoices = []
      data = load("data/invoices.csv")
      data.each do |line|
        @invoices << Invoice.new(line)
      end
      puts "Invoices Loaded"
    end

    def invoices
      @invoices
    end

    def invoices=(input)
      @invoices << input
    end

    def load_customers
      @customers = []
      data = load("data/customers.csv")
      data.each do |line|
        @customers << Customer.new(line)
      end
      puts "customers loaded"
    end

    def customers
      @customers
    end

    def customers=(input)
      @customers << input
    end

    def merchants=(input)
      @merchants << input
    end

    def load_invoice_items
      @invoice_items = []
      data = load("data/invoice_items.csv")
      data.each do |line|
        @invoice_items << InvoiceItem.new(line)
      end
      puts "Invoice Items Loaded"
    end

    def invoice_items
      @invoice_items
    end

    def load_transactions
      @transactions = []
      data = load("data/transactions.csv")
      data.each do |line|
        @transactions << Transaction.new(line)
      end
      puts "transactions Loaded"
    end

    def transactions
      @transactions
    end

    def find_by(class_name, attr, param)
      SalesEngine::Database.instance.send(class_name).find do |i|
        i.send(attr) == param
      end
    end

    def find_all_by(class_name, attr, param)
      SalesEngine::Database.instance.send(class_name).select do |i|
        i.send(attr) == param
      end
    end

    def all(class_name)
      SalesEngine::Database.instance.send(class_name)
    end
  end
end

database = SalesEngine::Database.instance
