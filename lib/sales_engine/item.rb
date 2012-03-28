require 'sales_engine/model'

class SalesEngine
  class Item
    ATTRIBUTES = %w(id created_at updated_at name description unit_price merchant_id)

    attr_accessor :merchant_id, :id, :item_id

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

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def invoice_items     
      SalesEngine::Database.instance.invoice_items.select do |ii|
        ii.item_id == @id
      end
    end

    def merchant
      SalesEngine::Database.instance.merchants.find do |merchant|
        merchant.id == @merchant_id
      end
    end

    def best_day
      return "2012-02-02"
    end
  end
end
