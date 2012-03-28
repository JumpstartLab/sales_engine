require 'sales_engine/model'


class SalesEngine
  class InvoiceItem
    ATTRIBUTES = ["id", "created_at", "updated_at", "item_id", "invoice_id",
               "quantity", "unit_price"]
    
    def self.finder_attributes
      ATTRIBUTES
    end

    include Model
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :total

    
    def initialize(attributes)
        super
        @item_id = attributes[:item_id]
        @invoice_id = attributes[:invoice_id]
        @quantity = attributes[:quantity]
        @unit_price = attributes[:unit_price]
    end

    def invoice
      SalesEngine::Invoice.find_by_id(@invoice_id)
    end

    def item
      
      SalesEngine::Item.find_by_id(@item_id)
    end

    def total
      @quantity.to_i * @unit_price.to_i
    end
  end
end


