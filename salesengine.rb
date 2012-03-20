$LOAD_PATH.unshift('./')
require 'csv'
require './customer'

class SalesEngine
  attr_accessor :customers

  def load_customers(filename="customers.csv")
    puts "Loading customers..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol} )
    self.customers = file.collect{ |line| Customer.new(line) }
  end
end

SE = SalesEngine.new()
SE.load_customers
puts SE.customers