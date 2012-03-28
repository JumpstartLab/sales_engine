require 'sales_engine/model'

class SalesEngine
  class Invoice
    ATTRIBUTES = %w(id created_at updated_at merchant_id customer_id merchant)
    attr_accessor :merchant_id, :customer_id, :customer, :id, :merchant
    
    def initialize(attributes)
      super
      @customer_id = attributes[:customer_id]
      @merchant_id = attributes[:merchant_id]
      @status = attributes[:status]
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def customer=(input)
      @customer_id = input.id
      @customer = input
    end

    def merchant=(input)
      @merchant_id = input.id
      @merchant = input
    end

    def transactions
      SalesEngine::Database.instance.transactions.select do |transaction|
       transaction.invoice_id == @id 
      end
    end

    def invoice_items
      SalesEngine::Database.instance.invoice_items.select do |invoice_item|
        invoice_item.invoice_id == @id
      end
    end

    def customer
      @customer || SalesEngine::Customer.find_by_id(@customer_id)
    end

    def merchant
      @merchant || SalesEngine::Merchant.find_by_id(@merchant_id)
    end

    def items
      invoice_items.collect do |invoice_item|
        invoice_item.item
      end
    end

    def total
      sum = 0
      invoice_items.each do |ii|
        sum += ii.total
      end
      sum
    end
  end
end
