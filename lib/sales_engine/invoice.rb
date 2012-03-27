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
   
    def self.random
      SalesEngine::Database.instance.invoices.sample
    end
    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def transactions
      SalesEngine::Database.instance.transactions.select do |transaction|
       transaction.invoice_id == @id 
      end
    end

    def invoice_items
      SalesEngine::Database.instance.invoice_items.select do |invoice_item|
        invoice_item.item_id == @id
      end
    end

    def customer
      SalesEngine::Database.instance.customers.find do |customer|
        customer.id == @customer_id
      end
    end

    def items
      invoice_items.collect do |invoice_item|
        invoice_item.item
      end
    end
  end
end
