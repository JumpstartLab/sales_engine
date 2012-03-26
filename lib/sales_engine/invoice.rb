require 'sales_engine/model'

class SalesEngine
  class Invoice
    include Model
    attr_accessor :merchant_id, :customer_id, :id
    
    def initialize(attributes)
      super
      @customer_id = attributes[:customer_id]
      @merchant_id = attributes[:merchant_id]
      @status = attributes[:status]
    end
    # def self.random
    #   # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    # def transactions
    #   # look in the array of all the transaction for the value in this
    #   # invoices @transaction and return it
    #   # Transaction.find_all_by_invoice(@transaction)
    # end

    # def invoice_items
    #   # returns a collection of associated InvoiceItem instances
    # end

    # def items
    #   # look in the array of all the items for the value in this
    #   # invoices @transaction and return it
    #   # Items.find_all_by_inovice(@items)
    # end

    # def customer
    #   # return the customer associated with this invoice
    # end
  end
end
