#require './merchant'
#require './invoice_item'
require './lib/sales_engine/database'
require './lib/sales_engine/find'

module SalesEngine
  class Item
    extend Find
   
   # id,name,description,unit_price,merchant_id,created_at,updated_at

    attr_accessor :id, :name, :description, :unit_price, :merchant_id, 
                  :created_at, :updated_at

    def initialize(attributes={})
      self.id           = attributes[:id]
      self.name         = attributes[:name]
      self.description  = attributes[:description]
      self.unit_price   = attributes[:unit_price]
      self.merchant_id  = attributes[:merchant_id]
      self.created_at   = attributes[:created_at]
      self.updated_at   = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :name, :description, :unit_price, :merchant_id, 
                  :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_items(attribute, input.to_s)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_items(attribute, input.to_s)
        end
      end
    end

    def self.random
      Database.instance.items.sample
    end

    def invoice_items
      #invoice_items returns an instance of InvoiceItems associated with this object
      Database.instance.invoice_items.select do |ii|
        ii.send(:item_id) == self.id
      end
    end

    def charged_invoice_items
      #invoice_items returns an instance of InvoiceItems associated with this object
      Database.instance.invoice_items.select do |ii|
        (ii.send(:item_id) == self.id) && ii.inv_success
      end
    end

    def best_day
      # best_day returns the date with the most sales for the given item
      rank = Hash.new(0)


      self.charged_invoice_items.each do |inv_item|
        inv = SalesEngine::Invoice.find_by_id(inv_item.invoice_id)
        rank[inv.date] += inv_item.quantity.to_i
      end
      rank = rank.sort_by{ |date, quant| quant }.reverse
      rank[0]
    end

    def merchant
      #merchant returns an instance of Merchant associated with this object
      Database.instance.merchants.find do |m|
        m.send(:id) == self.merchant_id
      end
    end

    def revenue
      revenue = 0
      self.charged_invoice_items.each do |ii|
        revenue += ( ii.quantity.to_i * ii.unit_price.to_i )
      end
      revenue
    end

    def self.most_revenue(num_of_items)
      # .most_revenue(x) returns the top x item instances ranked by total revenue generated
      rank = Hash.new(0)
      Database.instance.items.each do |item|
        rank[item] = item.revenue
      end
      rank = rank.sort_by{ |item, revenue| revenue}.reverse
      rank[1..num_of_items]
    end

    def quantity_sold
      quantity = 0
      self.charged_invoice_items.each do |inv_item|
        quantity += inv_item.quantity.to_i
      end
      quantity
    end

    def self.most_items(num_of_items)
      # .most_items(x) returns the top x item instances ranked by total number sold
      rank = Hash.new(0)
      Database.instance.items.each do |item|
        rank[item] = item.quantity_sold
      end
      rank = rank.sort_by{ |item, quant| quant }.reverse
      rank[1..num_of_items]
    end

  end
end