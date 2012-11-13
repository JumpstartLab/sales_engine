require 'csv'
require 'bigdecimal'
require 'date'
require 'time'

require 'sales_engine/database'
require 'sales_engine/customer'
require 'sales_engine/transaction'
require 'sales_engine/item'
require 'sales_engine/merchant'
require 'sales_engine/invoice_item'
require 'sales_engine/invoice'
require 'sales_engine/dynamic_finder'
require 'sales_engine/cleaner'

module SalesEngine
  class CsvLoader

    DB = SalesEngine::Database.instance

    def self.load(object_name)
      puts "Loading #{object_name}s..."

      filename = "./data/#{object_name}s.csv"

      file = CSV.open(filename, { :headers => true,
                                  :header_converters => :symbol})
      file.each do |line|
        name = object_name.split('_').map(&:capitalize).join('')
        value = eval "SalesEngine::#{name}"
        x = value.send(:new, line)
      end 
    end
  end
end