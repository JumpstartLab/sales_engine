require 'sales_engine/model'


class SalesEngine
  class InvoiceItem
    ATTRIBUTES = ["id", "created_at", "updated_at", "item_id", "invoice_id",
               "quantity", "unit_price"]
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :total

    def initialize(attributes)
        super
        @item_id = attributes[:item_id]
        @invoice_id = attributes[:invoice_id]
        @quantity = attributes[:quantity]
        @unit_price = attributes[:unit_price]
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def invoice
      SalesEngine::Database.instance.invoices.find do |invoice|
        invoice.id == @invoice_id
      end
    end

    def item
      SalesEngine::Database.instance.items.find do |item|
        item.id == @item_id
      end
    end

    def total
      @quantity.to_i * @unit_price.to_i
    end
  end
end


