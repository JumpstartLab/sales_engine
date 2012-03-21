require "sales_engine"

class Invoice
  include SalesEngine
  attr_accessor :id, :customer_id, :merchant_id,
                :status, :created_at, :updated_at
  def self.elements
    Database.invoices
  end
end