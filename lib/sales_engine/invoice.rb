require 'sales_engine/searchable'
require 'sales_engine/randomize'

module SalesEngine
  class Invoice
    extend Randomize
    extend Searchable

    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

    def initialize(attributes)
      self.id          = attributes[:id]
      self.customer_id = attributes[:customer_id]
      self.merchant_id = attributes[:merchant_id]
      self.status      = attributes[:status]
      self.created_at  = attributes[:created_at]
      self.updated_at  = attributes[:updated_at]
    end

    class << self
      [:id, :customer_id, :merchant_id, :status, 
       :created_at, :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_by_(attribute, input)
        end
      end

      [:id, :customer_id, :merchant_id, :status, 
       :created_at, :updated_at].each do |attribute|
        define_method "find_all_by_#{attribute}" do |input|
          find_all_by_(attribute, input)
        end
      end
    end

    def self.collection
      SalesEngine::Database.instance.invoices
    end

    def transactions
      items = SalesEngine::Database.instance.transactions
      results = items.select { |transaction| transaction.invoice_id == self.id }
    end

    def invoice_items
      items = SalesEngine::Database.instance.invoiceitems
      results = items.select { |invoiceitem| invoiceitem.invoice_id == self.id }
    end

    def items
      invoiceitems = SalesEngine::Database.instance.invoiceitems
      matched_invoiceitems = invoiceitems.select { |invoiceitem| invoiceitem.invoice_id == self.id }
      item_ids = matched_invoiceitems.map { |invoiceitem| invoiceitem.item_id }
      matched_items = item_ids.map { |item_id| SalesEngine::Item.find_by_id(item_id) }
    end

    def customer
      customers = SalesEngine::Database.instance.customers
      matched_customers = customers.select { |customer| customer.id == self.customer_id }
      matched_customers[0]
    end

  end
end