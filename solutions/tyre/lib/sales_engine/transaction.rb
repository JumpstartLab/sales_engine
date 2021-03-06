require 'sales_engine/class_methods'
require 'sales_engine/invoice'
require "date"
module SalesEngine
  class Transaction
    ATTRIBUTES = [:id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result,
                  :created_at, :updated_at]
    extend SearchMethods
    include AccessorBuilder

    def invoice
      @invoice ||= Database.instance.invoice[invoice_id][:self]
    end

    def successful?
      self.result == "success"
    end
  end
end