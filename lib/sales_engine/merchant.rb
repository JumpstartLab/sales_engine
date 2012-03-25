# require './item'
# require './invoice'
# require 'csv'
# require './sales_engine'
# require './customer' should only need to reference invoices > transactions
require './lib/sales_engine/find'

module SalesEngine
  class Merchant
    extend Find

    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(attributes={})
      if !attributes.nil? 
        self.id         = attributes[:id]
        self.name       = attributes[:name]
        self.created_at = attributes[:created_at]
        self.updated_at = attributes[:updated_at]
      end
    end

    class << self
      attributes = [:id, :name, :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_merchants(attribute, input.to_s)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_merchants(attribute, input.to_s)
        end
      end
    end

    def self.random
      Database.instance.merchants.sample
    end

    def items
      #returns a collection of Item instances associated with that merchant for the products they sell
      Database.instance.items.select do |i|
        i.send(:merchant_id) == self.id
      end
    end

    def invoices
      # returns a collection of Invoice instances associated with that merchant from their known orders
      Database.instance.invoices.select do |i|
        i.send(:merchant_id) == self.id
      end
    end

    def charged_invoices
      Database.instance.invoices.select do |i|
        (i.send(:merchant_id) == self.id) && i.transaction_successful?
      end
    end

    def revenue(date=nil)
      #if date?
        #revenue(date) returns the total revenue that merchant for a specific date
      #else
        # returns the total revenue for that merchant across all transactions

      rev = 0
      inv_item_ids = self.charged_invoices.collect { |i| i.id }
      inv_item_ids.each do |id|
        inv_item = Database.instance.invoice_items.find do |i|
          i.send(:id) == id
        end
        rev += (inv_item.unit_price.to_i * inv_item.quantity.to_i)
      end
      # need to return as BigDecimal
      rev
    end

    def self.most_revenue(num_of_merchants)
      # returns the top x merchant instances ranked by total revenue

    end

    def self.items(num_of_merchants)
      # returns the top x merchant instances ranked by total number of items sold
    end

    def self.revenue(date)
      # returns the total revenue for that date across all merchants
    end

    def favorite_customer
      #favorite_customer returns the Customer who has conducted the most transactions
      # should reference invoices > transactions
    end

    def customers_with_pending_invoices
      #customers_with_pending_invoices returns a collection of Customer instances which have pending (unpaid) invoices
    end

  end
end