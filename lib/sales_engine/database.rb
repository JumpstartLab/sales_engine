require 'csv'
require 'singleton'
require 'sales_engine/merchant'

class SalesEngine
  class Database
    include Singleton

    def initialize
      load_merchants
      puts "Merchants loaded"
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
    end

    def get_merchants
      @merchants
    end
  end
end

database = SalesEngine::Database.instance
