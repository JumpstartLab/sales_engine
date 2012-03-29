require 'sales_engine/database'
require 'sales_engine/find'

module SalesEngine
  class Item
    extend Find

    attr_accessor :id, :name, :description, :unit_price, :merchant_id,
                  :created_at, :updated_at

    def initialize(attributes={})
      self.id           = attributes[:id].to_i
      self.name         = attributes[:name]
      self.description  = attributes[:description]
      self.unit_price = BigDecimal.new(attributes[:unit_price])/100
      self.merchant_id  = attributes[:merchant_id].to_i
      self.created_at   = attributes[:created_at]
      self.updated_at   = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :name, :description, :unit_price, :merchant_id,
                  :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_items(attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_items(attribute, input)
        end
      end
    end

    def self.random
      Database.instance.items.sample
    end

    def invoice_items
      Database.instance.invoice_items.select do |ii|
        ii.send(:item_id) == self.id
      end
    end

    def charged_invoice_items
      Database.instance.invoice_items.select do |ii|
        (ii.send(:item_id) == self.id) && ii.inv_success
      end
    end

    def best_day
      rank = Hash.new(0)
      self.charged_invoice_items.each do |inv_item|
        inv = SalesEngine::Invoice.find_by_id(inv_item.invoice_id)
        rank[inv.date] += inv_item.quantity.to_i
      end
      rank = rank.sort_by{ |d, q| -q }
      rank[0][0]
    end

    def merchant
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

    def self.most_revenue(num_items)
      rank = Hash.new(0)
      Database.instance.items.each do |item|
        rank[item] = item.revenue
      end
      rank.sort_by{ |i, r| -r}[0...num_items].collect { |i, r| i }
    end

    def quantity_sold
      quantity = 0
      self.charged_invoice_items.each do |inv_item|
        quantity += inv_item.quantity.to_i
      end
      quantity
    end

    def self.most_items(num_items)
      rank = Hash.new(0)
      Database.instance.items.each do |item|
        rank[item] = item.quantity_sold
      end
      rank.sort_by{ |i, q| -q }[0...num_items].collect { |i, q| i }
    end

  end
end