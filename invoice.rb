require './record'

class Invoice < Record
  attr_accessor :customer_id, :merchant_id, :status

  def initialize(attributes = {})
    super
    self.customer_id = attributes[:customer_id]
    self.merchant_id = attributes[:merchant_id]
    self.status = attributes[:status]
  end
end