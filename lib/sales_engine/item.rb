require 'sales_engine/searchable'
require 'sales_engine/randomize'
require 'bigdecimal'

module SalesEngine
  class Item
    extend Randomize
    extend Searchable

    attr_accessor :id, :name, :description, :unit_price,
                  :merchant_id, :created_at, :updated_at

    def initialize(attributes)
      self.id = attributes[:id].to_i
      self.name = attributes[:name]
      self.description = attributes[:description]
      self.unit_price = sanitize_unit_price(attributes[:unit_price])
      self.merchant_id = attributes[:merchant_id].to_i
      self.created_at = Date.parse(attributes[:created_at])
      self.updated_at = Date.parse(attributes[:updated_at])
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
      database.items
    end

    def self.database
      SalesEngine::Database.instance
    end

    def database
      @database ||= SalesEngine::Database.instance
    end

    def database=(input)
      @database = input
    end

    def invoice_items
      database.invoiceitems.select {
        |invoice_item| invoice_item.item_id == self.id
      }
    end

    def merchant
      match_merchant_to_item[0]
    end

    def match_merchant_to_item
      database.merchants.select {
        |merchant| merchant.id == self.merchant_id
      }
    end

    def revenue
      @total ||= invoice_items.inject(0){
        |acc,num| num.total + acc
      }
    end

    def self.sort_by_revenue
      collection.sort { |a,b| b.revenue <=> a.revenue }
    end

    def self.most_revenue(param = 1)
      if param == 1
        sort_by_revenue.first
      else
        sort_by_revenue[0...param]
      end
    end

    def items_quantity
      @quantity ||= invoice_items.inject(0){
        |acc,num| num.quantity.to_i + acc
      }
    end

    def self.sort_by_items
      collection.sort {
        |a,b| b.items_quantity <=> a.items_quantity
      }
    end

    def self.most_items(param = 1)
      if param == 1
        sort_by_items.first
      else
        sort_by_items[0...param]
      end
    end

    def best_day
      results = Hash.new(0)
      paid_invoices.each do |invoice|
        results[invoice.created_at] += invoice.quantity.to_i
      end
      results.sort_by { |key,value| value }.last.first
    end

    private

    def sanitize_unit_price(original_price)
      BigDecimal(original_price.to_s)/100
    end

  end
end