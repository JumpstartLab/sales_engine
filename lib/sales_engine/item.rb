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

      def invoice_items
        InvoiceItem.find_all_by_item_id(self.id)
      end

      def merchant
        Merchant.find_all_by_item_id(self.id)
      end

  end
end