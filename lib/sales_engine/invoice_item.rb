require 'class_methods'
require 'item'
require 'invoice'
require "date"
module SalesEngine
  class InvoiceItem
    ATTRIBUTES = [:id, :invoice_id, :item_id, :quantity, :unit_price,
     :created_at, :updated_at]
     extend SearchMethods
     include AccessorBuilder

     def initialize (attributes = {})
      define_attributes(attributes)
      Database.instance.invoice_item[id.to_i][:self] = self
      Database.instance.invoice[invoice_id.to_i][:invoice_items] << self
      Database.instance.item[item_id.to_i][:invoice_items] << self
    end

    def invoice
      @invoice ||= Database.instance.invoice[invoice_id.to_i][:self]
    end

    def item
      @item ||= Database.instance.item[item_id.to_i][:self]
    end
  end
end