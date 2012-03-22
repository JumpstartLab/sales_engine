$LOAD_PATH.unshift './data'
$LOAD_PATH.unshift './lib/sales_engine/'
require 'csv'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'
require 'class_methods'

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
      CLASS_FILES.each do |klass, filename|
        file_to_objects(klass, filename)
      end
    end
    def self.load(filename)
      CSV.open("data/#{filename}", CSV_OPTIONS)
    end

    def self.file_to_objects(klass, filename)
      file = load(filename)
      method_name = filename.sub("s.csv","")
      file.each do |line|
        instance = klass.new(line.to_hash)
        Database.instance.send("#{method_name}") << instance
      end
    end

  end