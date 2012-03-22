class InvoiceItem
  attr_accessor :id,
                :item_id,
                :invoice_id,
                :quantity,
                :unit_price,
                :created_at,
                :updated_at

  def initialize(attributes={})
    self.invoice_item_id = attributes[:id].to_s
    self.item_id = attributes[:item_id].to_s
    self.invoice_id = attributes[:invoice_id].to_s
    self.quantity = attributes[:quantity].to_s
    self.unit_price = attributes[:unit_price].to_s
    self.created_at = attributes[:created_at].to_s
    self.updated_at = attributes[:updated_at].to_s
  end
end