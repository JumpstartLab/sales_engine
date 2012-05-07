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
      initialize_part_un(attributes)
      Database.instance.invoice[invoice_id][:invoice_items] << self
      Database.instance.item[item_id][:invoice_items] << self
    end

    def invoice
      @invoice ||= Database.instance.invoice[invoice_id][:self]
    end

    def item
      @item ||= Database.instance.item[item_id][:self]
    end

    def revenue
      @revenue ||= quantity * unit_price
    end
  end
end
