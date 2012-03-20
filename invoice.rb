class Invoice
  attr_accessor :invoice_id,
                :cust_id,
                :merchant_id,
                :status,
                :create_date,
                :update_date

  def initialize(invoice)
    self.invoice_id = invoice[:id].to_s
    self.cust_id = invoice[:customer_id].to_s
    self.merchant_id = invoice[:merchant_id].to_s
    self.status = invoice[:status].to_s
    self.create_date = invoice[:created_at].to_s
    self.update_date = invoice[:updated_at].to_s
  end

end