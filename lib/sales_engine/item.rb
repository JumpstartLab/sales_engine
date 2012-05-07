module SalesEngine
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

    def initialize(attrs)
      self.id = Cleaner::fetch_id("item", attrs[:id])
      self.name = attrs[:name]
      self.description = attrs[:description]
      self.unit_price = Cleaner::fetch_price(attrs[:unit_price])
      self.merchant_id = attrs[:merchant_id].to_i
      self.created_at = Cleaner::fetch_date(attrs[:created_at])
      self.updated_at = Cleaner::fetch_date(attrs[:updated_at])

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

    def self.aggregate_by_id(attr_to_aggregate)
      item_data = { }
      paid_invoice_items.each do |invoice_item|
        item_data[ invoice_item.item_id ] ||= 0
        item_data[ invoice_item.item_id ] += invoice_item.send(attr_to_aggregate.to_sym)
      end
      item_data
    end

    def self.most_revenue(num)
      sorted_results = aggregate_by_id("revenue").sort_by do |item_id, revenue|
        -revenue
      end

      sorted_results[0..(num-1)].collect do |item_id, revenue|
        SalesEngine::Item.find_by_id(item_id)
      end
    end

    def self.most_items(num)
      sorted_results = aggregate_by_id("quantity").sort_by do |item_id, quantity|
        -quantity
      end
      sorted_results[0..(num-1)].collect do |item_id, quantity|
        SalesEngine::Item.find_by_id(item_id)
      end
    end

    def item_quantity_by_day
      item_data = { }

      invoice_items.each do |invoice_item|
        item_data[ invoice_item.format_created_at ] ||= 0
        item_data[ invoice_item.format_created_at ] += invoice_item.quantity
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