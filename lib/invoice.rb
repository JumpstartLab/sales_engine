require './class_methods'
require './transaction'
require './item'
require './customer'
require "date"

class Invoice
  ATTRIBUTES = [:id, :customer_id, :merchant_id, :status, :created_at,
    :updated_at]
  extend SearchMethods
  extend AccessorBuilder


  def initialize(attributes = {})
    define_attributes(attributes)
  end

  def transactions
    Transaction.find_all_by_invoice_id(self.id)
  end

  def invoice_items
    Invoice.find_all_by_invoice_id(self.id)
  end

  def items
    Item.find_all_by_invoice_id(self.id)
  end

  def customer
    Customer.find_all_by_invoice_id(self.id)
  end
end