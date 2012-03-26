class SalesEngine
  class Invoice

    attr_accessor :merchant_id, :customer_id, :id
    
    def initialize(attributes)
      # puts attributes.inspect
      @id = attributes[:id]
      @customer_id = attributes[:customer_id]
      @merchant_id = attributes[:merchant_id]
      @status = attributes[:status]
      @created_at = attributes[:created_at]
      @updated_at = attributes[:updated_at]
    end
    # def self.random
    #   # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def transactions
      # look in the array of all the transaction for the value in this
      # invoices @transaction and return it
      # Transaction.find_all_by_invoice(@transaction)
      temp_transactions = SalesEngine::Database.instance.get_transactions
      correct_transactions = []
      temp_transactions.each do |transaction|
        if transaction.invoice_id == @id
          correct_transactions << transaction
        end
      end
      return correct_transactions
    end

    def invoice_items
      temp_invoice_items = SalesEngine::Database.instance.get_invoice_items
      correct_invoice_items = []
      temp_invoice_items.each do |invoice_item|
        if invoice_item.item_id == @id
          correct_invoice_items << invoice_item
        end
      end
      return correct_invoice_items
    end

    def customer
      temp_customers = SalesEngine::Database.instance.get_customers
      correct_customer = nil
      temp_customers.each do |the_customer|
        if the_customer.id == @customer_id
          correct_customer = the_customer
        end
      end
      correct_customer
    end

    def items
      temp_invoice_items = invoice_items
      correct_items = []
      temp_invoice_items.each do |the_ii|
        correct_items << the_ii.item
      end
      correct_items
    end

    # def customer
    #   # return the customer associated with this invoice
    # end
  end
end
