class Invoice
  attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

  def initialize(attributes = {})
    self.id = attributes[:id]
    self.customer_id = attributes[:customer_id]
    self.merchant_id = attributes[:merchant_id]
    self.status = attributes[:status]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  
end