require 'class_methods'
require 'invoice'
require "date"

class Transaction
  ATTRIBUTES = [:id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at]
  extend SearchMethods
  include AccessorBuilder

  def initialize (attributes = {})
    define_attributes(attributes)
  end

  def invoice
    Invoice.find_by_id(invoice_id)
  end
end