require 'csv'
# require '../data'
require 'sales_engine/customer'
require 'sales_engine/transaction'
require 'sales_engine/merchant'
require 'sales_engine/item'
require 'sales_engine/invoice'
require 'sales_engine/invoice_item'
require 'sales_engine/class_methods'

module SalesEngine
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  CLASS_FILES = {
    Customer => "customers.csv",
    InvoiceItem => "invoice_items.csv",
    Invoice => "invoices.csv",
    Item => "items.csv",
    Merchant => "merchants.csv",
    Transaction => "transactions.csv"}

    def self.startup
      threads = []
      CLASS_FILES.each do |klass, filename|
        threads << Thread.new do
          file_to_objects(klass, filename)
        end
      end
      threads.each {|thread| thread.join}
    end
    def self.load(filename)
      CSV.open("data/#{filename}", CSV_OPTIONS)
    end

    def self.file_to_objects(klass, filename)
      file = load(filename)
      method_name = filename.sub("s.csv","")
      file.each do |line|
        instance = klass.new(line.to_hash)
      end
    end
  end