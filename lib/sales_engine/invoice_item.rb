require './lib/sales_engine/record'

class InvoiceItem < Record
  attr_accessor :item_id, :invoice_id, :quantity, :unit_price

  def initialize(attributes = {})
    super
    self.item_id = attributes[:item_id]
    self.invoice_id = attributes[:invoice_id]
    self.quantity = attributes[:quantity]
    self.unit_price = attributes[:unit_price]
  end

  def invoice
    Database.instance.find_by("invoices", "id", self.invoice_id)
  end
end