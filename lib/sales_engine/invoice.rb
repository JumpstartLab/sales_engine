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
        Database.instance.invoice[id][:self] = self
        Database.instance.customer[customer_id][:invoices] << self
        Database.instance.merchant[merchant_id][:invoices] << self
        Database.instance.all_invoices[id - 1] = self
      end

      def all_invoices
        Database.instance.all_invoices
      end

      def transactions
        @transactions ||= Database.instance.invoice[id][:transactions]
      end

      def customer
        @customer ||= Database.instance.customer[customer_id][:self]
      end

      def invoice_items
        @invoice_items ||= Database.instance.invoice[id][:invoice_items]
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

      def pending?
        not successful?
      end

      def items_sold(date=nil)
        if date
          invoice_items.inject(0) do |sum, invoice_item|
            if self.created_at == date
              sum += invoice_item.quantity
            end
            sum
          end
        else
          invoice_items.inject(0) do |sum, invoice_item|
            sum += invoice_item.quantity
          end
        end
      end

      def charge(attributes = {})
        attributes[:invoice_id] = id.to_s
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
        parsed_attributes = {}
        parsed_attributes[:customer_id] = attributes[:customer].id.to_s
        parsed_attributes[:merchant_id] = attributes[:merchant].id.to_s
        last_invoice = Database.instance.all_invoices.max_by {|invoice| invoice.id}
        parsed_attributes[:id] = (last_invoice.id + 1).to_s

        accumulator = Hash.new {|hash,key| key = 0}
        attributes[:items].each do |item|
          accumulator[item] += 1
        end
        make_invoice_items(accumulator, parsed_attributes[:id].to_s)
        SalesEngine::Invoice.new(parsed_attributes)
      end

      def self.make_invoice_items(accumulator, id)
        last_i_item = Database.instance.all_invoice_items.max_by do |i_item|
          i_item.id
        end.id
        last_i_item += 1
        accumulator.each do |item,quantity|
          SalesEngine::InvoiceItem.new({
            :id => last_i_item.to_s,
            :invoice_id => id,
            :item_id => item.id.to_s, :quantity => quantity.to_s,
            :unit_price => item.unit_price.to_s,
            :created_at=> Date.today.to_s, :updated_at=> Date.today.to_s}
            )
          last_i_item += 1
        end
      end

      def self.pending
        pending = Database.instance.all_invoices.select {|invoice| invoice.pending?}
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
        BigDecimal.new((total_items/counter).to_s)
      end
    end
  end