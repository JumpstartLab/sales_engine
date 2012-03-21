$LOAD_PATH << './data'
require 'csv'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'
require 'database'

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
    @data = Hash.new() {|hash, key| hash[key] = []}
    CLASS_FILES.each do |klass, filename|
      file_to_objects(klass, filename)
    end
  end

  def load(filename)
    puts "#{filename} LOADING"
    CSV.open("data/#{filename}", CSV_OPTIONS)
  end

  def file_to_objects(klass, filename)
    file = load(filename)
    key = filename.delete(".csv")
    file.each do |line|
      instance = klass.new(line.to_hash)
      self.data[key.to_sym] << instance
    end
  end


  def data
    @data
  end
end