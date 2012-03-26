require 'class_methods'
require 'merchant'
require 'invoice_item'
require "date"
module SalesEngine
  class Item
    ATTRIBUTES = [:id, :name, :description, :unit_price, :merchant_id,
      :created_at, :updated_at]
      extend SearchMethods
      include AccessorBuilder

      def initialize(attributes = {})
        define_attributes(attributes)
      end

      def merchant
        @merchant ||= calc_merchant
      end

      def invoice_items
        @invoice_items ||= calc_invoice_items
      end

      def revenue
        @revenue ||= calc_revenue
      end

      def calc_invoice_items
        @invoice_items = InvoiceItem.find_all_by_item_id(self.id)
      end

      def calc_revenue
        revenue = 0
        revenue = self.invoice_items.inject(0) do |sum, invoice_item|
          sum += (invoice_item.quantity.to_i * invoice_item.unit_price.to_i)
        end
        @revenue = BigDecimal.new(revenue)
      end


      def calc_merchant
        @merchant = Merchant.find_by_id(merchant_id)
      end

      def self.most_revenue(number)
        sorted = Database.instance.item.sort_by {|item| -item.revenue}
        sorted.slice(0...number)
      end

      def self.most_items(number)
        items_count = Hash.new {|hash, key| hash[key] = 0}
        items = Database.instance.item
        items.sort_by do |item|
          
        end
      end
    end
  end