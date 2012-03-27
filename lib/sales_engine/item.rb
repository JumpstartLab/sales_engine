require 'class_methods'
require 'merchant'
require 'invoice_item'
require "date"
require "awesome_print"
module SalesEngine
  class Item
    ATTRIBUTES = [:id, :name, :description, :unit_price, :merchant_id,
      :created_at, :updated_at]
      attr_accessor :invoice_items, :merchant
      extend SearchMethods
      include AccessorBuilder

      def initialize(attributes = {})
        define_attributes(attributes)
        Database.instance.item[id.to_i][:self] = self
        Database.instance.merchant[merchant_id.to_i][:items] << self
      end

      def merchant
        @merchant ||= Database.instance.merchant[merchant_id.to_i][:self]
      end

      def invoice_items
        @invoice_items ||= Database.instance.item[id.to_i][:invoice_items]
      end

      def revenue
        @revenue ||= calc_revenue
      end

      def items_sold
        @items_sold ||= calc_items_sold
      end

      def calc_items_sold
        self.invoice_items.inject(0) do |sum, invoice_item|
          sum+=invoice_item.quantity.to_i
        end
      end

      def calc_revenue
        revenue = 0
        revenue = self.invoice_items.inject(0) do |sum, invoice_item|
          sum += (invoice_item.quantity.to_i * invoice_item.unit_price.to_i)
        end
        @revenue = BigDecimal.new(revenue)
      end

      def best_day
        date_counts = Hash.new {|hash, key| hash[key] = 0 }
        highest = 0
        top_day = nil
        self.invoice_items.each do |invoice_item|
          if invoice_item.invoice.successful?
            date_counts[invoice_item.created_at] += 1
            count = date_counts[invoice_item.created_at]
            if count > highest
              highest = count
              top_day = invoice_item.created_at
            end
          end
        end
        top_day
      end


      def self.most_revenue(number)
        all_items = Database.instance.item.collect do |i, hash|
          Database.instance.item[i][:self]
        end
        sorted_items = all_items.sort_by do |item|
          -item.revenue
        end
        top_items = sorted_items.slice(0...number)
      end

      def self.most_items(number)
        all_items = Database.instance.item.collect do |i, hash|
          Database.instance.item[i][:self]
        end
        sorted_items = all_items.sort_by do |item|
          -item.items_sold
        end
        top_items = sorted_items.slice(0...number)
      end
    end
  end