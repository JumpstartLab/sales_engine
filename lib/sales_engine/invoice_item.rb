require 'sales_engine/model'


class SalesEngine
  class InvoiceItem
    ATTRIBUTES = ["id", "created_at", "updated_at", "item_id", "invoice_id",
               "quantity", "unit_price"]
    
    def self.finder_attributes
      ATTRIBUTES
    end

    include Model
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :total, :updated_at, :unit_price

    def initialize(attributes)
        super
        @item_id = attributes[:item_id].to_i
        @invoice_id = attributes[:invoice_id].to_i
        @quantity = attributes[:quantity].to_i
        @unit_price = BigDecimal.new(attributes[:unit_price]).round(2)
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


