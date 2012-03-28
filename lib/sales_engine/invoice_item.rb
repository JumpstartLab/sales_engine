require 'sales_engine/class_methods'
require 'sales_engine/item'
require 'sales_engine/invoice'
require "date"
module SalesEngine
  class InvoiceItem
    ATTRIBUTES = [:id, :invoice_id, :item_id, :quantity, :unit_price,
     :created_at, :updated_at]
     extend SearchMethods
     include AccessorBuilder

     def initialize (attributes = {})
      define_attributes(attributes)
      Database.instance.invoice_item[id][:self] = self
      Database.instance.invoice[invoice_id][:invoice_items] << self
      Database.instance.item[item_id][:invoice_items] << self
      Database.instance.all_invoice_items[id - 1] = self
    end

    def invoice
      @invoice ||= Database.instance.invoice[invoice_id][:self]
    end

    def item
      @item ||= Database.instance.item[item_id][:self]
    end

    def revenue
      @revenue||= quantity * unit_price
    end
  end
end