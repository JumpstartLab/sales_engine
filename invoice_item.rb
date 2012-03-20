class InvoiceItem
  attr_accessor :invoice_item_id,
                :item_id,
                :invoice_id,
                :quantity,
                :unit_price,
                :create_date,
                :update_date

  def initialize(invoice_items)
    self.invoice_item_id = invoice_items[:id].to_s
    self.item_id = invoice_items[:item_id].to_s
    self.invoice_id = invoice_items[:invoice_id].to_s
    self.quantity = invoice_items[:quantity].to_s
    self.unit_price = invoice_items[:unit_price].to_s
    self.create_date = invoice_items[:created_at].to_s
    self.update_date = invoice_items[:updated_at].to_s
  end
end