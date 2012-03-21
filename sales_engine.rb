$LOAD_PATH << './'
$LOAD_PATH << './lib'
require 'csv'
require 'customer'
require 'transaction'
require 'merchant'
require 'item'
require 'invoice'
require 'invoice_item'

class SalesEngine
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  CLASS_FILES = {Customer => "customers.csv", Invoice => "invoice_items.csv",
    Invoice => "invoices.csv", Item => "items.csv",
    Merchant => "merchants.csv", Transaction => "transactions.csv"}

    def initialize
      @data = Hash.new([])
      CLASS_FILES.each do |klass, filename|
        file = load(filename)
        key = filename.delete(".csv")
        lines_to_objects(file)
      end
    end

    def load(filename)
      CSV.open(filename, CSV_OPTIONS)
    end

    def lines_to_objects(file)
     file.collect do |line|
      if not line.header_row?
        instance = klass.new(line.to_hash)
        @data[key] << instance
      end 
    end
  end

  #LOAD STUFF:
  # invoices
  # customers
  # merchants
  # invoice_items
  # transactions
  # items

  # test them how?
  # count should match # of lines in CSV (minus 1 for headers)?
  # 1. each collection is an array
  # 2. each entity in each collection is an object of proper type

  # load_files (dynamically?)
  # given static array of files/types-of-objects to load,
  # it can probably load all files with one somewhat dynamic method

  # STORAGE:
  # instance variables (each one is an array)
  # wrapper methods for internal arrays?




end