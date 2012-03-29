module SalesEngine
  require 'sales_engine/dynamic_finder'
  class Item
    attr_accessor :id, :name, :description, :unit_price,
                  :merchant_id, :created_at, :updated_at

    ITEM_ATTS = [
      # "id",
      "name",
      "description",
      "unit_price",
      "merchant_id",
      "created_at",
      "updated_at"
      ]

    def initialize(attributes)
      self.id = attributes[:id].to_i
      self.name = attributes[:name]
      self.description = attributes[:description]
      if attributes[:unit_price]
        self.unit_price = BigDecimal.new(attributes[:unit_price])/100 
      end
      self.merchant_id = attributes[:merchant_id].to_i
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]

      SalesEngine::Database.instance.item_list << self
      SalesEngine::Database.instance.item_id_hash[ self.id ] = self
    end

    def self.attributes_for_finders
      ITEM_ATTS
    end

    extend SalesEngine::DynamicFinder

    # def self.find_by_id(id)
    #   SalesEngine::Database.instance.item_id_hash[ id ]
    # end

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
        item_data[ invoice_item.item_id ] ||= 0
        item_data[ invoice_item.item_id ] += invoice_item.revenue
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
        invoice_item_id = invoice_item.item_id
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
        date_str = invoice_item.invoice.updated_at.strftime("%Y/%m/%d")
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