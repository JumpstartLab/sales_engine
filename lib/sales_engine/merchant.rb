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
      inv_items = []

      self.charged_invoices.each do |inv|
        inv.invoice_items.each do |inv_item|
          inv_items << inv_item
        end
      end

      inv_items.each do |inv_item|
        rev += (inv_item.unit_price.to_i * inv_item.quantity.to_i)
      end
      rev
    end

    def self.most_revenue(num_of_merchants)
      # returns the top x merchant instances ranked by total revenue
      rank = Hash.new
      Database.instance.merchants.each do |merchant|
        rank[merchant] = merchant.revenue
      end
      rank = rank.sort_by{ |id, rev| rev }.reverse
      rank[1..num_of_merchants]

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

      # this just finds the most invoices by a particular customer
      cust_ids = self.charged_invoices.collect { |i| i.customer_id }
      count = Hash.new(0)
      cust_ids.each { |id| count[id] += 1 }
      fav_cust_id = count.sort_by{ |id, count| count }.last[0]
      Customer.find_by_id(fav_cust_id)

    end

    def customers_with_pending_invoices
      #customers_with_pending_invoices returns a collection of Customer instances which have pending (unpaid) invoices
    end

  end
end