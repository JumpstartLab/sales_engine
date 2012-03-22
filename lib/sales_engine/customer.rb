require './lib/sales_engine/database'
#require './lib/sales_engine/invoice'
#require './transaction'
# require './merchant' should only need to reference invoices > transactions?

module SalesEngine
  class Customer
    # id,first_name,last_name,created_at,updated_at

    CUSTOMERS     = []
    CSV_OPTIONS   = {:headers => true, :header_converters => :symbol}
    CUSTOMER_DATA = "customers.csv"

    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    # define_method("find_by_#{attribute}") do |query|
    #   klass.send(find, query)
    # end

    # Module: extended(base)

    def initialize(attributes={})
      self.id         = attributes[:id]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]

      # attributes.each do |attribute|
      #   define_method("find_by_#{attribute}") { Database.instance.customers.find { |c| c.first_name == first_name} }
      
      # end

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

    # def find_by_blah
    #   Search.call
    # end

    def self.find_by_first_name(first_name)
      Database.instance.customers.find { |c| c.first_name == first_name}
    end

    def self.find_all_by_first_name(first_name)
      Database.instance.customers.select { |c| c.first_name == first_name}
    end

  end
end