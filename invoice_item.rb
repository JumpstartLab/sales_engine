class InvoiceItem
  attr_accessor :invoice_item_id,
                :item_id,
                :invoice_id,
                :quantity,
                :unit_price,
                :create_date,
                :update_date

  def initialize(attributes={})
    self.invoice_item_id = attributes[:id].to_s
    self.item_id = attributes[:item_id].to_s
    self.invoice_id = attributes[:invoice_id].to_s
    self.quantity = attributes[:quantity].to_s
    self.unit_price = attributes[:unit_price].to_s
    self.create_date = attributes[:created_at].to_s
    self.update_date = attributes[:updated_at].to_s
  end
end