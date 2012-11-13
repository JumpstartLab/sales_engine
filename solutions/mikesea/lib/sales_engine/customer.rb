require 'sales_engine/database'
require 'sales_engine/find'

module SalesEngine
  class Customer
    extend Find

    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    def initialize(attributes={})
      self.id         = attributes[:id].to_i
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :first_name, :last_name, :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find("customers", attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all("customers", attribute, input)
        end
      end
    end

    def self.random
      Database.instance.customers.sample
    end

    def invoices
      Database.instance.invoices.select do |i|
        i.send(:customer_id) == self.id
      end
    end

    def transactions
      self.invoices.select do |inv|
        inv.transactions
      end
    end

    def favorite_merchant
      merch_ids = self.invoices.collect { |i| i.merchant_id }
      count = Hash.new(0)
      merch_ids.each { |id| count[id] += 1 }
      fav_merch_id = count.sort_by{ |id, count| count }.last[0]
      Merchant.find_by_id(fav_merch_id)
    end

  end
end