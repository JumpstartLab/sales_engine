require 'sales_engine/class_methods'
require 'sales_engine/transaction'
require 'sales_engine/item'
require 'sales_engine/customer'
require "date"

module SalesEngine
  class Invoice
    ATTRIBUTES = [:id, :customer_id, :merchant_id, :status, :created_at,
      :updated_at]
      extend SearchMethods
      include AccessorBuilder

      def initialize(attributes = {})
        define_attributes(attributes)
        Database.instance.invoice[id.to_i][:self] = self
        Database.instance.customer[customer_id.to_i][:invoices] << self
        Database.instance.merchant[merchant_id.to_i][:invoices] << self
        Database.instance.all_invoices[id.to_i - 1] = self
      end

      def all_invoices
        Database.instance.all_invoices
      end

      def transactions
        @transactions ||= Database.instance.invoice[id.to_i][:transactions]
      end

      def customer
        @customer ||= Database.instance.customer[customer_id.to_i][:self]
      end

      def invoice_items
        @invoice_items ||= Database.instance.invoice[id.to_i][:invoice_items]
      end

      def items
        @items ||= self.invoice_items.collect do |invoice_item|
          invoice_item.item
        end
      end

      def revenue(date = nil)
        if date
          @revenue ||= calc_revenue_by_date(date)
        else
          @revenue ||= calc_revenue
        end
      end

      def successful?
        if transactions.any?
          transactions.last.successful?
        end
      end

      def items_sold(date=nil)
        if date
          invoice_items.inject(0) do |sum, invoice_item|
            if self.created_at == date
              sum += invoice_item.quantity.to_i
            end
            sum
          end
        else
          invoice_items.inject(0) do |sum, invoice_item|
            sum += invoice_item.quantity.to_i
          end
        end
      end

      def charge(attributes = {})
        Transaction.new(attributes)
      end

      def calc_revenue
        revenue = invoice_items.inject(0) do |sum, invoice_item|
          sum += invoice_item.revenue
        end
      end

      def calc_revenue_by_date (date=nil)
        revenue = invoice_items.inject(0) do |sum, invoice_item|
          if successful? && self.created_at == date
            sum += invoice_item.revenue
          end
          sum
        end
      end

      def self.create(attributes = {})
        self.new(attributes)
      end

      def self.pending
        pending = all_invoices.select {|invoice| not invoice.successful?}
      end

      def self.average_revenue(date = nil)
        counter = 0
        total_revenue = Database.instance.all_invoices.inject(0) do |sum, invoice|
          revenue = invoice.revenue(date)
          counter += 1 unless revenue == 0
          sum += revenue
        end
        average_revenue = total_revenue/counter
      end

      def self.average_items(date)
        counter = 0
        total_items = Database.instance.all_invoices.inject(0) do |sum, invoice|
          if invoice.successful?
            items_sold = invoice.items_sold(date)
            counter += 1 unless items_sold == 0
            sum += items_sold
          end
        end
        BigDecimal.new(total_items/counter)
      end
    end
  end