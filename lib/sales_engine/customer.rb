require 'csv'
require 'sales_engine/searchable'
require 'sales_engine/randomize'

module SalesEngine
  class Customer
    extend Randomize
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
    end

    def self.collection
      SalesEngine::Database.instance.customers
    end

    def invoices
      invoices = SalesEngine::Database.instance.invoices
      results = invoices.select { |invoice| invoice.customer_id == self.id }
    end

  end
end