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

      def update
        @transactions ||= calc_transactions
        @customer ||= calc_customer
        @invoice_items ||= calc_invoice_items
        @items ||= calc_items
        @revenue ||= calc_revenue
      end

      def transactions
        @transactions ||= calc_transactions
      end

      def customer
        @customer ||= calc_customer
      end

      def invoice_items
        @invoice_items ||= calc_invoice_items
      end

      def items
        @items ||= calc_items
      end

      def revenue
        @revenue ||= calc_revenue
      end

      def calc_transactions
        @transactions = Transaction.find_all_by_invoice_id(self.id)
      end

      def calc_invoice_items
        @invoice_items = InvoiceItem.find_all_by_invoice_id(self.id)
      end

      def calc_items
        @items = invoice_items.collect do |invoice_item|
          invoice_item.item
        end
      end

      def calc_revenue
        total_revenue = 0
        if successful?
          total_revenue = invoice_items.inject(0) do |sum, invoice_item|
            sum += (invoice_item.unit_price.to_i * invoice_item.quantity.to_i)
          end
        end
        @revenue = BigDecimal.new(total_revenue)
      end

      def successful?
        if transactions.any?
          transactions.last.successful?
        end
      end

      def calc_customer
        @customer = Customer.find_by_id(self.customer_id)
      end
    end
  end