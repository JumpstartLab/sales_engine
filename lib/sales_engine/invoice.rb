require 'sales_engine/model'

class SalesEngine
  class Invoice
    ATTRIBUTES = %w(id created_at updated_at merchant_id customer_id merchant)
    def self.finder_attributes
      ATTRIBUTES
    end

    include Model
    attr_accessor :merchant_id, :customer_id, :customer, :id, :merchant, :updated_at
    
    def initialize(attributes)
      super
      @customer_id = attributes[:customer_id]
      @merchant_id = attributes[:merchant_id]
      @status = attributes[:status]
    end  

    def customer=(input)
      @customer_id = input.id
      @customer = input
    end

    def merchant=(input)
      @merchant_id = input.id
      @merchant = input
    end

    def transactions
      SalesEngine::Transaction.find_all_by_invoice_id(@id)
    end

    def invoice_items
      SalesEngine::InvoiceItem.find_all_by_invoice_id(@id)
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
      @total || invoice_items.inject(0) {|sum, element| sum + element.total}
    end

    def total=(input)
      @total = input
    end
  end
end
