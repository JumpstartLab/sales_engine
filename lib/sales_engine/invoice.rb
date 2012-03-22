$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"

module SalesEngine
  class Invoice
    include SalesEngine
    attr_accessor :id, :customer_id, :merchant_id,
    :status, :created_at, :updated_at
    def initialize(id, customer_id, merchant_id, status, created_at, updated_at)
      @id = id
      @customer_id = customer_id
      @merchant_id = merchant_id
      @status = status
      @created_at = created_at
      @updated_at = updated_at
    end
    def self.elements
      Database.invoices
    end

    def transactions
      Database.transactions.select { |transaction| transaction.invoice_id == id }
    end

    def invoice_items
      Database.invoice_items.select { |invoice_item| invoice_item.invoice_id == id }
    end

    def items
      invoice_items = Database.invoice_items.select do |invoice_item|
        invoice_item.invoice_id == id
      end
      invoice_items.collect { |invoice_item| invoice_item.item }
    end

    def customer
      Database.customers.find { |customer| customer.id == customer_id}
    end
  end
end