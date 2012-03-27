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
        Database.instance.invoice[id.to_i][:self] = self
        Database.instance.customer[customer_id.to_i][:invoices] << self
        Database.instance.merchant[merchant_id.to_i][:invoices] << self
      end

      def self.create(attributes = {})
        self.new(attributes)
      end

      def self.pending
        all_invoices = Database.instance.invoice.collect do |i, hash|
          Database.instance.invoice[i][:self]
        end
        pending = all_invoices.select {|invoice| not invoice.successful?}
      end

      def self.average_revenue(date = nil)
        all_invoices = Database.instance.invoice.collect do |i, hash|
          Database.instance.invoice[i][:self]
        end
        counter = 0
        total_revenue = all_invoices.inject(0) do |sum, invoice|
          revenue = invoice.revenue(date)
          counter += 1 unless revenue == 0
          sum += revenue
        end
        average_revenue = total_revenue/counter
      end

      def self.average_items(date)
        all_invoices = Database.instance.invoice.collect do |i, hash|
          Database.instance.invoice[i][:self]
        end
        counter = 0
        total_items = all_invoices.inject(0) do |sum, invoice|
          if invoice.successful?
            items_sold = invoice.items_sold(date)
            counter += 1 unless items_sold == 0
            sum += items_sold
          end
        end
        BigDecimal.new(total_items/counter)
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
          revenue = invoice_items.inject(0) do |sum, invoice_item|
            if successful? && self.created_at == date
              sum += invoice_item.quantity.to_i * invoice_item.unit_price.to_i
            end
            sum
          end
        else
          @revenue ||= calc_revenue
        end
      end

      def calc_revenue
        total_revenue = 0
        if successful?
          invoice_items.each do |invoice_item|
            amount = invoice_item.quantity.to_i * invoice_item.unit_price.to_i
            total_revenue += amount
          end
        end
        BigDecimal.new(total_revenue)
      end

      def successful?
        if transactions.any?
          transactions.last.successful?
        end
      end
    end
  end