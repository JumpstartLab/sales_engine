require 'sales_engine/searchable'
require 'sales_engine/randomize'

module SalesEngine
  class Invoice
    extend Randomize
    extend Searchable

    attr_accessor :id, :customer_id, :merchant_id,
                  :status, :created_at, :updated_at

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
      database.invoices
    end

    def self.database
      SalesEngine::Database.instance
    end

    def database
      @database ||= SalesEngine::Database.instance
    end

    def database=(input)
      @database = input
    end

    def transactions
      database.transactions.select {
        |transaction| transaction.invoice_id == self.id
      }
    end

    def invoice_items
      results = database.invoiceitems.select {
        |invoiceitem| invoiceitem.invoice_id == self.id
      }
    end

    def items
      get_item_ids.map {
        |item_id| SalesEngine::Item.find_by_id(item_id)
      }
    end

    def get_item_ids
      matched_invoiceitems.map { |invoiceitem| invoiceitem.item_id }
    end

    def matched_invoiceitems
      database.invoiceitems.select {
        |invoiceitem| invoiceitem.invoice_id == self.id
      }
    end

    def customer
      matched_customers[0]
    end

    def matched_customers
      database.customers.select {
        |customer| customer.id == self.customer_id
      }
    end

    def paid?
      transactions.any? do |t|
        t.successful?
      end
    end

    def total_amount
      if paid?
        @total ||= invoice_items.inject(0) do |sum,inv_item|
          sum + inv_item.total
        end
      else
        return 0
      end
    end

    def revenue_by_date(date)
      result = 0
      if paid? && self.created_at == date
        invoice_items.each do |invoice_item|
          result += invoice_item.total
        end
      end
      result
    end

    def revenue
      matched_invoiceitems.total
    end

    def get_revenue

    end

    def total_items
      invoice_items.inject(0) { |sum,ii| sum + ii.quantity.to_i }
    end

  end
end