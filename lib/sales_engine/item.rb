require 'sales_engine/class_methods'
require 'sales_engine/merchant'
require 'sales_engine/invoice_item'
require "date"
module SalesEngine
  class Item
    ATTRIBUTES = [:id, :name, :description, :unit_price, :merchant_id,
      :created_at, :updated_at]
      attr_accessor :invoice_items, :merchant
      extend SearchMethods
      include AccessorBuilder

      def initialize(attributes = {})
        define_attributes(attributes)
        Database.instance.item[id][:self] = self
        Database.instance.merchant[merchant_id][:items] << self
        Database.instance.all_items[id - 1] = self
      end

      def merchant
        @merchant ||= Database.instance.merchant[merchant_id][:self]
      end

      def invoice_items
        @invoice_items ||= Database.instance.item[id][:invoice_items]
      end

      def revenue
        @revenue ||= calc_revenue
      end

      def items_sold
        @items_sold ||= calc_items_sold
      end

      def self.sum(thing)
        self.invoice_items.inject(0) do |sum, invoice_item|
          if invoice_item.invoice.successful?
            sum+=invoice_item.send(thing)
          end
          sum
        end
      end

      def calc_items_sold
        sum(quantity)
      end

      def calc_revenue
        sum(revenue)
      end

      def best_day
        date_counts = Hash.new {|hash, key| hash[key] = 0 }
        top_day = nil
        self.invoice_items.each do |ii|
          if ii.invoice.successful?
            date_counts[ii.invoice.created_at] += ii.quantity
          end
        end
        top_day = date_counts.max_by{|k, v| v}
        top_day[0]
      end

      def self.sort_items_by(criterion)
        Database.all_items.sort_by do |item|
          -item.send(criterion)
        end
      end

      def self.most_revenue(number)
        sort_items_by(revenue).slice(0...number)
      end

      def self.most_items(number)
        sort_items_by(items_sold).slice(0...number)
      end
    end
  end
