require 'class_methods'
require 'item'
require 'invoice'
require "date"
module SalesEngine
  class InvoiceItem
    ATTRIBUTES = [:id, :invoice_id, :item_id, :quantity, :unit_price,
     :created_at, :updated_at]
     attr_reader :invoice, :item
     extend SearchMethods
     include AccessorBuilder

     def initialize (attributes = {})
      define_attributes(attributes)
      update
    end

    def update
      calc_invoice
      calc_item
    end

    def calc_invoice
      @item = Invoice.find_by_id(self.invoice_id)
    end

    def calc_item
      @item = Item.find_by_id(self.item_id)
    end
  end
end