require 'sales_engine'
require 'sales_engine/find'

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
          find("merchants", attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all("merchants", attribute, input)
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

    def revenue(date=nil)
      rev = 0
      self.charged_invoices(date).each do |inv|
        rev += inv.revenue
      end
      rev
    end

    def self.most_revenue(num_merchants)
      rank = Hash.new
      Database.instance.merchants.each do |merchant|
        rank[merchant] = merchant.revenue
      end
      rank.sort_by{ |m, r| -r }[0...num_merchants].collect { |m, r| m }
    end

    def self.revenue(date)
      rev = 0
      Database.instance.merchants.each do |merchant|
        rev += merchant.revenue(date)
      end
      rev
    end

    def charged_invoices(d=nil)
      if d
        self.charged_invoices_by_date(d)
      else
        Database.instance.invoices.select do |i|
          (i.send(:merchant_id) == self.id) && i.success
        end
      end
    end

    def charged_invoices_by_date(d)
      Database.instance.invoices.select do |i|
          ((i.send(:merchant_id) == self.id) && i.send(:date) == d) && i.success
      end
    end

    def self.most_items(num_merchants)
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
      cust_ids = self.charged_invoices.collect { |i| i.customer_id }
      count = Hash.new(0)
      cust_ids.each { |id| count[id] += 1 }
      fav_cust_id = count.sort_by{ |id, count| count }.last[0]
      Customer.find_by_id(fav_cust_id)
    end

    def pending_invoices
      self.invoices.select do |inv|
        !inv.success
      end
    end

    def customers_with_pending_invoices
      self.pending_invoices.collect do |inv|
        Customer.find_by_id(inv.customer_id)
      end
    end

  end
end