$LOAD_PATH << './data'
$LOAD_PATH << './lib/sales_engine/'
require 'csv'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'
require 'class_methods'

module SalesEngine
  class SalesEngine
    CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
    CLASS_FILES = {
      Customer => "customers.csv",
      InvoiceItem => "invoice_items.csv",
      Invoice => "invoices.csv",
      Item => "items.csv",
      Merchant => "merchants.csv",
      Transaction => "transactions.csv"}

    def initialize
      CLASS_FILES.each do |klass, filename|
        file_to_objects(klass, filename)
      end
    end

    def load(filename)
      CSV.open("data/#{filename}", CSV_OPTIONS)
    end

    def file_to_objects(klass, filename)
      file = load(filename)
      method_name = filename.sub("s.csv","")
      file.each do |line|
        instance = klass.new(line.to_hash)
        Database.instance.send("#{method_name}") << instance
      end
    end
  end
end