class Invoice
  attr_accessor :invoice_id,
                :cust_id,
                :merchant_id,
                :status,
                :create_date,
                :update_date

  def initialize(attributes={})
    self.invoice_id = attributes[:id].to_s
    self.cust_id = attributes[:customer_id].to_s
    self.merchant_id = attributes[:merchant_id].to_s
    self.status = attributes[:status].to_s
    self.create_date = attributes[:created_at].to_s
    self.update_date = attributes[:updated_at].to_s
  end

end