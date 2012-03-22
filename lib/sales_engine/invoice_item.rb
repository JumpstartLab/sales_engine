$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"

module SalesEngine
  class InvoiceItem
    include SalesEngine
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price,
    :created_at, :updated_at

    def initialize(id, item_id, invoice_id, quantity, unit_price, created_at, updated_at) 
      @id = id
      @item_id = item_id
      @invoice_id = invoice_id
      @quantity = quantity
      @unit_price = unit_price
      @created_at = created_at
      @updated_at = updated_at
    end               

    def self.elements
      Database.invoice_items
    end

    def item 
      Database.items.find { |item| item.id == item_id }  
    end
  end
end