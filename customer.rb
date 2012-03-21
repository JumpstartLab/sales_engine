require './invoice'
require './transaction'
# require './merchant' should only need to reference invoices > transactions?

class Customer
  # id,first_name,last_name,created_at,updated_at

  CUSTOMERS     = []
  CSV_OPTIONS   = {:headers => true, :header_converters => :symbol}
  CUSTOMER_DATA = "customers.csv"

  attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

  def initialize(attributes={})
    self.id         = attributes[:id]
    self.first_name = attributes[:first_name]
    self.last_name = attributes[:last_name]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def self.load_data
    cust_file = CSV.open(CUSTOMER_DATA, CSV_OPTIONS)
    cust_file.collect do |c| 
      CUSTOMERS << Customer.new(c)
    end
    puts "Loaded Customer data."
  end

  def invoices
    #invoices returns a collection of Invoice instances associated with this object.
  end

  def transactions
    #transactions returns an array of Transaction instances associated with the customer
  end

  def favorite_merchant
    #favorite_merchant returns an instance of Merchant where the customer has conducted the most transactions
    # will reference invoices > transactions class to determine count
  end

  def self.find_by_first_name(first_name)
    q
  end

end