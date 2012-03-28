$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"
require "sales_engine/invoice_record"

module SalesEngine
  class Invoice
    include SalesEngine
    extend InvoiceRecord
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
      invoices
    end

    def transactions
      SalesEngine::Database.instance.transactions.select { |transaction| transaction.invoice_id == id }
    end

    def invoice_items
      SalesEngine::Database.instance.invoice_items.select { |invoice_item| invoice_item.invoice_id == id }
    end

    def items
      invoice_items = SalesEngine::Database.instance.invoice_items.select do |invoice_item|
        invoice_item.invoice_id == id
      end
      invoice_items.collect { |invoice_item| invoice_item.item }
    end

    def customer
      SalesEngine::Database.instance.customers.find { |customer| customer.id == customer_id}
    end

    def charge(input)
      input[:invoice_id] = id
      Database.instance.insert_transaction(input)
    end

    def self.create(input)
      invoice_hash = {}
      invoice_hash[:customer_id] = input[:customer].id
      invoice_hash[:merchant_id] = input[:merchant].id
      invoice_hash[:status] = input[:status]
      invoice_id = Database.instance.insert_invoice(invoice_hash)

      create_invoice_items(input[:items], invoice_id)
      Invoice.find_by_id(invoice_id)
    end

    def self.create_invoice_items(items, invoice_id)
      items_hash = {}
      items.each do |item|
        items_hash[item.id] = [items.count(item), item.unit_price]
      end

      items_hash.each do |item_id, values|
        Database.instance.insert_invoice_item({:item_id => item_id , :invoice_id => invoice_id,
                                              :quantity => values[0], :unit_price => values[1] })
      end
    end
  end
end
