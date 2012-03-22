#require './merchant'
#require './invoice_item'
require './lib/sales_engine/database'

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

    def invoice_items
      #invoice_items returns an instance of InvoiceItems associated with this object
    end

    def merchant
      #merchant returns an instance of Merchant associated with this object
    end

    def self.most_revenue(num_of_items)
      # .most_revenue(x) returns the top x item instances ranked by total revenue generated
    end

    def self.most_items(num_of_items)
      # .most_items(x) returns the top x item instances ranked by total number sold
    end

    def best_day
      # best_day returns the date with the most sales for the given item
    end
  end
end