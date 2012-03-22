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

    def self.random
      puts "#{Database.instance.customers.sample.inspect}"
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

  end
end