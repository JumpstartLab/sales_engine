require "sales_engine"
require "invoice"

class Merchant
  include SalesEngine
  attr_accessor :id, :name, :created_at, :updated_at
  
  def initialize(id, name, created_at, updated_at)
    @id = id
    @name = name
    @created_at = created_at
    @updated_at = updated_at
  end

  def invoices
    Database.invoices.select { |invoice| invoice.merchant_id == id }
  end

  def self.elements
    Database.merchants
  end  
end
