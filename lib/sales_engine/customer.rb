require 'csv'
require 'sales_engine/searchable'

module SalesEngine
  class Customer
    
    extend Searchable

    attr_accessor :id, :first_name, :last_name, :created_at,
                  :updated_at

    def initialize(attributes)
      self.id = attributes[:id]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    class << self
      [:id, :first_name, :last_name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_by_(attribute, input)
        end
      end

      [:id, :first_name, :last_name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_all_by_#{attribute}" do |input|
          find_all_by_(attribute, input)
        end
      end

      define_method "random" do 
        random(collection)
      end
    end

    def self.random
      rand(self.customers)
    end

    def self.invoices
      Invoice.find_by_customer_id(id)
      customer = Customer.find_by_id()
      SalesEngine::Invoice.find_all_by_customer_id(value)

    end

    def self.collection
      SalesEngine::Database.instance.customers
    end

    # def invoices
    #   # returns a collection of Invoice instances associated with this object
    # end

  end
end