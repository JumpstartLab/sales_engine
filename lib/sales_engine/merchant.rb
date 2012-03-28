# require './item'
# require './lib/sales_engine/invoice'
 require './lib/sales_engine'
# require './customer' should only need to reference invoices > transactions
require './lib/sales_engine/find'

module SalesEngine
  class Merchant
    extend Find

    attr_accessor :id, :name, :created_at, :updated_at, :revenue

    def initialize(attributes={})
      self.id         = attributes[:id].to_i
      self.name       = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :name, :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_merchants(attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_merchants(attribute, input)
        end
      end
    end

    def self.random
      Database.instance.merchants.sample
    end

    def items
      SalesEngine::Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      SalesEngine::Invoice.find_all_by_merchant_id(self.id)
    end

    # def revenue(date=nil)
    #   rev = 0
    #   self.charged_invoices(date).each do |inv|
    #     inv.invoice_items.each do |inv_item|
    #       rev += (inv_item.unit_price.to_i * inv_item.quantity.to_i)
    #     end
    #   end
    #   rev
    # end

    # def revenue(date=nil)
    #   self.charged_invoices(date).map { |i| i.revenue }.inject(:+)
    # end

    def revenue(date=nil)
      #rev = BigDecimal.new("")
      rev = 0
      self.charged_invoices(date).each do |inv|
        rev += inv.revenue
      end
      rev
    end

    def self.most_revenue(num_merchants)
      # returns the top x merchant instances ranked by total revenue
      rank = Hash.new
      Database.instance.merchants.each do |merchant|
        rank[merchant] = merchant.revenue
      end
      rank.sort_by{ |m, r| -r }[0...num_merchants].collect { |m, r| m }
    end

    def self.revenue(date)
      # returns the total revenue for that date across all merchants
      rev = 0
      Database.instance.merchants.each do |merchant|
        rev += merchant.revenue(date)
      end
      rev
    end

    def charged_invoices(date=nil)
      if date
        Database.instance.invoices.select do |i|
          ((i.send(:merchant_id) == self.id) && i.send(:date) == date) && i.success
        end
      else
        #Invoice.find_all_by_merchant_id(self.id)
        Database.instance.invoices.select do |i|
          (i.send(:merchant_id) == self.id) && i.success
        end
      end
    end

    def self.most_items(num_merchants)
      # returns the top x merchant instances ranked by total number of items sold
      rank = Hash.new
      Database.instance.merchants.each do |merch|
        quantity = 0
        merch.items.each do |item|
          quantity += item.quantity_sold
        end
        rank[merch] = quantity
      end
      rank.sort_by { |m, q| -q }[0...num_merchants].collect{ |m,q| m }
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