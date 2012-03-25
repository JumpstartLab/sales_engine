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

      def update
        @invoice_items ||= calc_invoice_items
        @merchant ||= calc_merchant
      end

      def calc_invoice_items
        @invoice_items = InvoiceItem.find_all_by_item_id(self.id)
      end

      def calc_merchant
        @merchant = Merchant.find_by_id(merchant_id)
      end

    end
  end