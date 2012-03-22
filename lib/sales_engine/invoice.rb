require 'class_methods'
require 'transaction'
require 'item'
require 'customer'
require "date"

module SalesEngine
  class Invoice
    ATTRIBUTES = [:id, :customer_id, :merchant_id, :status, :created_at,
      :updated_at]
      extend SearchMethods
      include AccessorBuilder


      def initialize(attributes = {})
        define_attributes(attributes)
      end

      def transactions
        Transaction.find_all_by_invoice_id(self.id)
      end

      def invoice_items
        InvoiceItem.find_all_by_invoice_id(self.id)
      end

      def items
        invoice_items = InvoiceItem.find_all_by_invoice_id(self.id)
        matches = invoice_items.select do |invoice_item|
          invoice_item.invoice_id == self.id
        end
        matches.collect do |invoice_item|
          invoice_item.item
        end
      end

      def revenue
        revenue = 0
        if successful?
          revenue = invoice_items.inject(0) do |sum, invoice_item|
            sum += (invoice_item.unit_price.to_i * invoice_item.quantity.to_i)
          end
        end
        BigDecimal.new(revenue)
      end

      def successful?
        if transactions.any?
          transactions.last.successful?
        end
      end

      def customer
        Customer.find_by_id(self.customer_id)
      end
    end
  end