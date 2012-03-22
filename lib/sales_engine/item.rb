$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"

module SalesEngine
  class Item
    include SalesEngine
    attr_accessor :id, :name, :description, :unit_price,
    :merchant_id, :created_at, :updated_at

    def initialize(id, name, description, unit_price, merchant_id, created_at, updated_at) 
      @id = id
      @name = name
      @description = description
      @unit_price = unit_price
      @merchant_id = merchant_id
      @created_at = created_at
      @updated_at = updated_at
    end               

    def self.elements
      Database.items
    end

    def merchant
      Database.merchants.find { |merchant| merchant.id == id}
    end

    def invoice_items
      Database.invoice_items.select { |invoice_item| invoice_item.item_id == id}
    end
  end
end