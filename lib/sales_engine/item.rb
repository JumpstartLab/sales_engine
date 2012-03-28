require 'sales_engine/model'

class SalesEngine
  class Item
    ATTRIBUTES = %w(id created_at updated_at name description unit_price merchant_id )

    attr_accessor :merchant_id, :id, :item_id, :name, :description, :unit_price, :created_at, :updated_at

    def initialize(attributes)
      super
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]
      @merchant_id = attributes[:merchant_id]
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def invoice_items     
      SalesEngine::InvoiceItem.find_all_by_item_id(@id)
    end

    def merchant
      SalesEngine::Merchant.find_by_id(@merchant_id)
    end

    def best_day
      puts "TODO #{self.class}"
      return "2012-02-02"
    end
  end
end
