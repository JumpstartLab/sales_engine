module SalesEngine
  require 'sales_engine/dynamic_finder'
  class Item
    attr_accessor :id, :name, :description, :unit_price,
                  :merchant_id, :created_at, :updated_at

    ITEM_ATTS = [
      "id",
      "name",
      "description",
      "unit_price",
      "merchant_id",
      "created_at",
      "updated_at"
      ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.description = attributes[:description]
      self.unit_price = attributes[:unit_price]
      self.merchant_id = attributes[:merchant_id]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def self.attributes_for_finders
      ITEM_ATTS
    end

    extend SalesEngine::DynamicFinder

    def invoice_items
      SalesEngine::InvoiceItem.find_all_by_item_id(self.id)
    end

    def self.paid_invoice_items
      SalesEngine::InvoiceItem.successful_invoice_items
    end

    def merchant
      SalesEngine::Merchant.find_by_id(self.merchant_id)
    end

    def self.item_revenue_by_id
      item_data = { }

      paid_invoice_items.each do |invoice_item|
        item_data[ invoice_item.item_id.to_sym ] ||= 0
        item_data[ invoice_item.item_id.to_sym ] += invoice_item.revenue
      end
      item_data
    end

    def self.most_revenue(num)
      sorted_results = item_revenue_by_id.sort_by do |item_id, revenue|
        -revenue
      end

      sorted_results[0..(num-1)].collect do |item_id, revenue|
        SalesEngine::Item.find_by_id(item_id)
      end
    end

    def self.item_quantity_by_id
      item_data = { }

      paid_invoice_items.each do |invoice_item|
        invoice_item_id = invoice_item.item_id.to_sym
        item_data[ invoice_item_id ] ||= 0
        item_data[ invoice_item_id ] += invoice_item.quantity
      end
      item_data
    end

    def self.most_items(num)
      sorted_results = item_quantity_by_id.sort_by do |item_id, quantity|
        -quantity
      end

      sorted_results[0..(num-1)].collect do |item_id, quantity|
        SalesEngine::Item.find_by_id(item_id)
      end
    end

    def item_quantity_by_day
      item_data = { }

      invoice_items.each do |invoice_item|
        date_str = invoice_item.updated_at.strftime("%Y/%m/%d")
        item_data[ date_str ] ||= 0
        item_data[ date_str ] += invoice_item.quantity
      end
      item_data
    end

    def best_day
      sorted_results = item_quantity_by_day.sort_by do |day, quantity|
        -quantity
      end
      Date.parse(sorted_results.first[0])
    end
  end
end