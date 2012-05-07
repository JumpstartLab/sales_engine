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

    ARRAY_TYPES = ["Merchant", "Item", "Invoice", "Customer", "InvoiceItem", "Transaction"]

    def initialize
      # load_merchants

      ARRAY_TYPES.each do |a|
        load_data(a)
      end
    end

    def load(filename)
      CSV.open(filename, :headers => true, :header_converters => :symbol)
    end

    def load_data(type)
      instance_variable_set(("@" + type.underscores), [])
      data = load("data/#{type.underscores}.csv")
      data.each do |line|
        instance_variable_get("@" + type.underscores) << SalesEngine.const_get(type).new(line)
      end
      puts "#{type} loaded"
    end


    def merchants
      @merchants
    end


    def items
      @items
    end

    def items=(input)
      @items = input
    end


    def invoices
      @invoices
    end

    def invoices=(input)
      @invoices << input
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

    def invoice_items
      @invoice_items
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
