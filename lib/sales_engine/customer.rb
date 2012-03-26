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
      Database.instance.customers.sample
    end

    def invoices
      #invoices returns a collection of Invoice instances associated with this object.
      Database.instance.invoices.select do |i|
        i.send(:customer_id) == self.id
      end
    end

    def transactions
      #transactions returns an array of Transaction instances associated with the customer
      invoice_ids = self.invoices.collect { |i| i.id }
      invoice_ids.collect do |inv_id|
        Database.instance.transactions.select do |t|
          t.send(:invoice_id) == inv_id
        end
      end
    end

    def favorite_merchant
      #favorite_merchant returns an instance of Merchant where the customer has conducted the most transactions
      # will reference invoices > transactions class to determine count

      merch_ids = self.invoices.collect { |i| i.merchant_id }
      count = Hash.new(0)
      merch_ids.each { |id| count[id] += 1 }
      fav_merch_id = count.sort_by{ |id, count| count }.last[0]
      Merchant.find_by_id(fav_merch_id)
    end

  end
end