require 'sales_engine/searchable'
require 'sales_engine/randomize'
require 'bigdecimal'

module SalesEngine
  class Item
    extend Randomize
    extend Searchable

    attr_accessor :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at

    def initialize(attributes)
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.description = attributes[:description]
      self.unit_price = attributes[:unit_price]
      self.merchant_id = attributes[:merchant_id]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    class << self
      [:id, :name, :description, :unit_price, 
       :merchant_id, :created_at, 
       :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_by_(attribute, input)
        end
      end

      [:id, :name, :description, :unit_price, 
       :merchant_id, :created_at, 
       :updated_at].each do |attribute|
        define_method "find_all_by_#{attribute}" do |input|
          find_all_by_(attribute, input)
        end
      end
    end

    def self.collection
      SalesEngine::Database.instance.items
    end

    def invoice_items
      invoiceitems = SalesEngine::Database.instance.invoiceitems
      matched_invoiceitems = invoiceitems.select { |invoiceitem| invoiceitem.item_id == self.id }
    end
    
    def merchant
      merchants = SalesEngine::Database.instance.merchants
      matched_merchants = merchants.select { |merchant| merchant.id == self.merchant_id }
      matched_merchants[0]
    end

    ####REVENUE####

    def items_revenue
      self.invoice_items.inject(0){ |acc,num| num.revenue + acc }
    end

    def self.sort_revenue_list
      collection[0..2].sort { |a,b| b.items_revenue <=> a.items_revenue }
    end

    def self.most_revenue(param)
      sort_revenue_list[0...param]
    end

    ######ITEM######

    def items_quantity
      self.invoice_items.inject(0){ |acc,num| num.quantity.to_i + acc }
    end

    def self.sort_items_list
      collection.sort { |a,b| b.items_quantity <=> a.items_quantity }
    end

    def self.most_items(param)
      sort_items_list[0...param]
    end

    ####BEST-DAY####

    

  end
end