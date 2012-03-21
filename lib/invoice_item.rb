require './class_methods'
require './item'
require './invoice'
require "date"

class InvoiceItem
  ATTRIBUTES = [:id, :invoice_id, :item_id, :quantity, :unit_price,
   :created_at, :updated_at]
   extend SearchMethods
   extend AccessorBuilder

   def initialize (attributes = {})
    define_attributes(attributes)
  end

  def invoice
    Invoice.find_by_id(self.invoice_id)
  end

  def item
    Item.find_by_id(self.item_id)
  end
end