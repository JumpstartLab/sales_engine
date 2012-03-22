require 'csv'
require 'singleton'
require 'sales_engine/merchant'
require 'sales_engine/invoice'
require 'sales_engine/customer'

class SalesEngine
  class Database
    include Singleton

    def initialize
      load_merchants
      load_items
      load_invoices
      load_customers
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

    def get_merchants
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
 
    def get_items
      @items
    end

    def load_invoices
      @invoices = []
      data = load("data/invoices.csv")
      data.each do |line|
        @invoices << Invoice.new(line)
      end
      puts "Invoices Loaded"
    end

    def get_invoices
      @invoices
    end

    def load_customers
      @customers = []
      data = load("data/customers.csv")
      data.each do |line|
        @customers << Customer.new(line)
      end
      puts "customers loaded"
    end

    def get_customers
      @customers
    end

  end
end

database = SalesEngine::Database.instance
