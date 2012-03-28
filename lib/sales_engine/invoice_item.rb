$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"
require "sales_engine/invoice_item_finder"

module SalesEngine
  class InvoiceItem
    include SalesEngine
    extend InvoiceItemFinder

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
      SalesEngine::Database.instance.invoice_items
    end

    def item 
      SalesEngine::Database.instance.items.find { |item| item.id == item_id }  
    end

    def invoice
      SalesEngine::Database.instance.invoices.find { |invoice| invoice.id == invoice_id }  
    end
  end
end
