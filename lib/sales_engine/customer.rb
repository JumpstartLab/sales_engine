require './lib/sales_engine/database'
require './lib/sales_engine/find'

module SalesEngine 
  class Customer
    extend Find
    # id,first_name,last_name,created_at,updated_at

    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    def initialize(attributes={})
      self.id         = attributes[:id]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    # Module: extended(base)

    class << self
      attributes = [:id, :first_name, :last_name, :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_customers(attribute, input.to_s)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_customers(attribute, input.to_s)
        end
      end
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

    # def self.find_by_first_name(first_name)
    #   Database.instance.customers.find { |c| c.first_name == first_name}
    # end

    # def self.find_all_by_first_name(first_name)
    #   Database.instance.customers.select { |c| c.first_name == first_name}
    # end

  end
end