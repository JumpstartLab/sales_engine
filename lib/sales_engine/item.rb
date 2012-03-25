module SalesEngine
  class Item
    attr_accessor :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at

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

    ITEM_ATTS.each do |att|
      define_singleton_method ("find_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.item_list.detect do |item|
          item.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    ITEM_ATTS.each do |att|
      define_singleton_method ("find_all_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.item_list.select do |item|
          item if item.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    def invoice_items
      SalesEngine::InvoiceItem.find_all_by_item_id(self.id)
    end

    def merchant
      SalesEngine::Merchant.find_by_id(self.merchant_id)
    end
  end
end